//
//  RealityExerciseAnimationView.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 16.10.2026.
//


import UIKit
import RealityKit

/// RealityKit-версия вью для анимации упражнения.
/// - Поддерживает циклические (`loop: true`) и одноразовые (`loop: false`) сцены.
/// - Играет **только первую** анимацию из `availableAnimations`.
///   Mixamo/Blender иногда кладут в USDZ несколько клипов (rest-pose + основной).
///   Если запустить все сразу, второй контроллер «перебивает» первый, и `isComplete`
///   у первого мгновенно становится `true`, хотя визуально играет второй.
/// - Для одноразовых сцен `completion` вызывается после фактического завершения
///   клипа (через polling `isComplete`).
/// - Запуск анимации откладывается на первый кадр (`CADisplayLink`), чтобы
///   сцена точно успела стать активной.
/// - Поддерживает подмену тела на лету (см. `swapBody`).
final class RealityExerciseAnimationView: UIView {

    // MARK: - UI

    private let arView: ARView = {
        let view = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: false)
        view.backgroundColor = .clear
        view.environment.background = .color(.clear)
        view.renderOptions.insert(.disableMotionBlur)
        view.renderOptions.insert(.disableDepthOfField)
        view.renderOptions.insert(.disableCameraGrain)
        view.renderOptions.insert(.disableGroundingShadows)
        view.renderOptions.insert(.disableHDR)
        view.automaticallyConfigureSession = false
        return view
    }()

    // MARK: - Scene graph

    private let rootAnchor = AnchorEntity(world: .zero)
    private let pivotEntity = Entity()
    private let cameraEntity = Entity()

    // MARK: - State

    private var currentModelEntity: Entity?
    private var currentSceneModel: SceneModel?
    private var currentBounds: BoundingBox?
    private var persistentScale: Float?
    private var hasSetUpCamera = false
    private var cameraAzimuthOffset: Float = 0
    private var transitionToken = UUID()
    private var playbackControllers: [AnimationPlaybackController] = []

    /// Активная (запущенная) анимация текущей сцены.
    /// Сохраняется, чтобы при `swapBody` применить её к новому телу.
    private var currentAnimation: AnimationResource?
    private var currentLoop: Bool = true

    // MARK: - Completion polling

    private var completionTimer: Timer?
    private var completionHandler: (() -> Void)?
    private var completionController: AnimationPlaybackController?
    private var completionToken: UUID?

    // MARK: - First-frame scheduling

    /// Запуск анимации откладывается на первый кадр рендеринга.
    private var firstFrameLink: CADisplayLink?
    private var pendingAnimationSetup: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    deinit {
        firstFrameLink?.invalidate()
        firstFrameLink = nil
    }

    private func setup() {
        backgroundColor = .clear
        addSubview(arView)
        arView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: topAnchor),
            arView.leadingAnchor.constraint(equalTo: leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: trailingAnchor),
            arView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Камера
        let camera = PerspectiveCamera()
        camera.camera.fieldOfViewInDegrees = 45
        camera.camera.near = 0.01
        camera.camera.far = 1000
        cameraEntity.addChild(camera)
        pivotEntity.addChild(cameraEntity)

        // Свет — три источника
        let key = DirectionalLight()
        key.light.intensity = 4000
        key.light.color = .white
        key.look(at: .zero, from: [1.5, 2.5, 1.5], relativeTo: nil)

        let fill = DirectionalLight()
        fill.light.intensity = 2000
        fill.light.color = .white
        fill.look(at: .zero, from: [-1.5, 0.5, 1.0], relativeTo: nil)

        let rim = DirectionalLight()
        rim.light.intensity = 1500
        rim.light.color = .white
        rim.look(at: .zero, from: [0, 1, -2], relativeTo: nil)

        rootAnchor.addChild(pivotEntity)
        rootAnchor.addChild(key)
        rootAnchor.addChild(fill)
        rootAnchor.addChild(rim)

        arView.scene.addAnchor(rootAnchor)
    }

    // MARK: - Reset

    func reset() {
        transitionToken = UUID()
        cancelPendingFirstFrame()
        stopAllAnimations()
        currentModelEntity?.removeFromParent()
        currentModelEntity = nil
        currentAnimation = nil
        persistentScale = nil
        hasSetUpCamera = false
        currentSceneModel = nil
        currentBounds = nil
        cameraAzimuthOffset = 0
    }

    // MARK: - Preload

    func preload(scenes: [SceneModel], completion: (() -> Void)? = nil) {
        let names = Set(scenes.map(\.name))
        RealityExerciseCache.shared.preload(names: names, completion: completion)
    }

    // MARK: - Play

    func play(scene exerciseScene: SceneModel,
              alternating: Bool = false,
              loop: Bool = true,
              completion: (() -> Void)? = nil) {
        let token = UUID()
        transitionToken = token

        RealityExerciseCache.shared.loadEntity(named: exerciseScene.name) { [weak self] loaded in
            guard let self = self, self.transitionToken == token else { return }
            guard let loaded = loaded else { completion?(); return }

            let entity = loaded.clone(recursive: true)

            self.install(entity: entity,
                         scene: exerciseScene,
                         loop: loop,
                         completion: completion,
                         token: token)
        }
    }

    private func install(entity: Entity,
                         scene: SceneModel,
                         loop: Bool,
                         completion: (() -> Void)?,
                         token: UUID) {
        // ---- Масштаб ----
        let rawBounds = entity.visualBounds(relativeTo: nil)
        let rawHeight = rawBounds.extents.y
        let scale: Float
        if let saved = persistentScale {
            scale = saved
        } else {
            let desiredHeight: Float = 2.0
            scale = rawHeight > 0 ? desiredHeight / rawHeight : 1.0
            persistentScale = scale
        }
        entity.scale = SIMD3<Float>(repeating: scale)

        // ---- Подмена модели ----
        cancelPendingFirstFrame()
        stopAllAnimations()
        currentModelEntity?.removeFromParent()
        rootAnchor.addChild(entity)
        currentModelEntity = entity

        // ---- Данные для камеры ----
        currentSceneModel = scene
        currentBounds = entity.visualBounds(relativeTo: nil)

        if !hasSetUpCamera {
            hasSetUpCamera = true
            updateCameraPosition(animated: false)
        } else {
            updateCameraPosition(animated: true)
        }

        // ---- Запуск анимации после первого кадра ----
        scheduleAnimationSetup(entity: entity,
                               loop: loop,
                               completion: completion,
                               token: token)
    }

    // MARK: - First-frame scheduling

    private func scheduleAnimationSetup(entity: Entity,
                                        loop: Bool,
                                        completion: (() -> Void)?,
                                        token: UUID) {
        cancelPendingFirstFrame()

        pendingAnimationSetup = { [weak self] in
            guard let self = self, self.transitionToken == token else { return }
            self.startAnimation(entity: entity,
                                loop: loop,
                                completion: completion,
                                token: token)
        }

        let link = CADisplayLink(target: self, selector: #selector(handleFirstFrame))
        link.add(to: .main, forMode: .common)
        firstFrameLink = link
    }

    @objc
    private func handleFirstFrame() {
        // Важно: забираем setup ДО очистки, иначе он обнулится.
        let setup = pendingAnimationSetup

        firstFrameLink?.invalidate()
        firstFrameLink = nil
        pendingAnimationSetup = nil

        setup?()
    }

    private func cancelPendingFirstFrame() {
        firstFrameLink?.invalidate()
        firstFrameLink = nil
        pendingAnimationSetup = nil
    }

    // MARK: - Animation start

    /// Запускает **только первую** анимацию из `availableAnimations`.
    ///
    /// Почему не все:
    /// Mixamo/Blender иногда кладут в один USDZ несколько клипов
    /// (например, rest-pose + основной). При `playAnimation` на нескольких
    /// ресурсах второй контроллер «перебивает» первый, и у первого
    /// `isComplete` мгновенно становится `true`, хотя визуально играет второй.
    /// В результате polling завершения срабатывает по «пустышке».
    private func startAnimation(entity: Entity,
                                loop: Bool,
                                completion: (() -> Void)?,
                                token: UUID) {
        guard transitionToken == token else { return }

        let animations = entity.availableAnimations

        #if DEBUG
        print("▶️ startAnimation: scene=\(currentSceneModel?.name ?? "?"), " +
              "loop=\(loop), availableAnimations.count=\(animations.count)")
        #endif

        guard let firstAnimation = animations.first else {
            // Нет анимации — статичная поза. Завершаем сразу.
            #if DEBUG
            print("ℹ️ \(currentSceneModel?.name ?? "?") без анимации — статичная поза")
            #endif
            currentAnimation = nil
            currentLoop = loop
            DispatchQueue.main.async { [weak self] in
                guard let self = self, self.transitionToken == token else { return }
                completion?()
            }
            return
        }

        currentAnimation = firstAnimation
        currentLoop = loop

        let resource = loop ? firstAnimation.repeat() : firstAnimation
        let controller = entity.playAnimation(resource,
                                              transitionDuration: 0,
                                              startsPaused: false)
        playbackControllers.append(controller)

        // ---- Completion ----
        guard let completion = completion else { return }

        if loop {
            // Для циклической сцены — завершение сразу (никто не ждёт конца).
            DispatchQueue.main.async { [weak self] in
                guard let self = self, self.transitionToken == token else { return }
                completion()
            }
            return
        }

        startCompletionPolling(controller: controller,
                               completion: completion,
                               token: token)
    }

    // MARK: - Completion polling

    /// Проверяет завершение одноразовой анимации.
    ///
    /// Защиты:
    /// - `hasObservedPlaying` — принимаем `isComplete == true` только если
    ///   хотя бы раз видели `isComplete == false` (защита от «фантомного»
    ///   `true` сразу после `playAnimation`).
    /// - `maxTicks` — через 30 секунд принудительно завершаем, чтобы не
    ///   залипнуть на `.transition`, если анимация повреждена.
    private func startCompletionPolling(controller: AnimationPlaybackController,
                                        completion: @escaping () -> Void,
                                        token: UUID) {
        stopCompletionPolling()

        completionHandler = completion
        completionController = controller
        completionToken = token

        var hasObservedPlaying = false
        var ticks = 0
        let maxTicks = 300

        #if DEBUG
        print("⏳ Polling started (token: \(token))")
        #endif

        completionTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            ticks += 1

            guard self.transitionToken == token else {
                #if DEBUG
                print("⚠️ Polling cancelled: token mismatch")
                #endif
                self.stopCompletionPolling()
                return
            }

            let isComplete = controller.isComplete

            if !hasObservedPlaying, !isComplete {
                hasObservedPlaying = true
                #if DEBUG
                print("▶️ Animation observed playing (tick \(ticks))")
                #endif
            }

            #if DEBUG
            if ticks % 5 == 0 {
                print("🔍 tick \(ticks): isComplete=\(isComplete), hasPlayed=\(hasObservedPlaying)")
            }
            #endif

            if hasObservedPlaying && isComplete {
                #if DEBUG
                print("✅ Animation completed at tick \(ticks)")
                #endif
                self.stopCompletionPolling()
                DispatchQueue.main.async { completion() }
                return
            }

            if ticks >= maxTicks {
                #if DEBUG
                print("⏰ Hard timeout — forcing completion")
                #endif
                self.stopCompletionPolling()
                DispatchQueue.main.async { completion() }
                return
            }
        }
    }

    private func stopCompletionPolling() {
        completionTimer?.invalidate()
        completionTimer = nil
        completionHandler = nil
        completionController = nil
        completionToken = nil
    }

    // MARK: - Body swap

    /// Меняет тело, применяя ту же анимацию, что играет сейчас.
    /// Берём `currentAnimation` (а не `availableAnimations` нового тела),
    /// чтобы не зависеть от того, какие клипы случайно попали в его USDZ.
    func swapBody(to bodyName: String, completion: ((Bool) -> Void)? = nil) {
        guard let oldEntity = currentModelEntity else { completion?(false); return }
        let scene = currentSceneModel
        let animation = currentAnimation
        let loop = currentLoop

        RealityExerciseCache.shared.loadEntity(named: bodyName) { [weak self] loaded in
            guard let self = self, let loaded = loaded else {
                completion?(false); return
            }
            let newBody = loaded.clone(recursive: true)

            if let scale = self.persistentScale {
                newBody.scale = SIMD3<Float>(repeating: scale)
            }

            self.stopAllAnimations()
            oldEntity.removeFromParent()
            self.rootAnchor.addChild(newBody)
            self.currentModelEntity = newBody

            var applied = false
            if let animation = animation {
                let resource = loop ? animation.repeat() : animation
                let controller = newBody.playAnimation(resource,
                                                       transitionDuration: 0,
                                                       startsPaused: false)
                self.playbackControllers.append(controller)
                applied = true
            }

            if let scene = scene {
                self.currentBounds = newBody.visualBounds(relativeTo: nil)
                self.currentSceneModel = scene
                self.updateCameraPosition(animated: false)
            }

            completion?(applied)
        }
    }

    // MARK: - Rendering control

    func pauseRendering() {
        playbackControllers.forEach { $0.pause() }
    }

    func resumeRendering() {
        playbackControllers.forEach { $0.resume() }
    }

    // MARK: - Camera orbit

    func setCameraAzimuthOffset(_ azimuthOffset: Float) {
        cameraAzimuthOffset = azimuthOffset
        updateCameraPosition(animated: false)
    }

    func resetCameraAzimuthOffset() {
        cameraAzimuthOffset = 0
        updateCameraPosition(animated: false)
    }

    private func updateCameraPosition(animated: Bool) {
        guard let scene = currentSceneModel, let bounds = currentBounds else { return }

        let center = bounds.center
        let radius = max(bounds.extents.x, max(bounds.extents.y, bounds.extents.z)) * 0.5
        let effectiveAzimuth = scene.azimuth + cameraAzimuthOffset

        let lookAtTarget = SIMD3<Float>(
            center.x + radius * scene.scaledCenterMulX,
            center.y + radius * scene.scaledCenterMulY,
            center.z + radius * scene.scaledCenterMulZ
        )
        let radiusOrbit = radius * scene.radiusOrbitMul
        let elevation = scene.elevation

        pivotEntity.position = lookAtTarget
        pivotEntity.orientation = simd_quatf(angle: effectiveAzimuth, axis: [0, 1, 0])

        let localY = radiusOrbit * sin(elevation)
        let localZ = radiusOrbit * cos(elevation)
        cameraEntity.position = SIMD3<Float>(0, localY, localZ)
        cameraEntity.orientation = simd_quatf(angle: -elevation, axis: [1, 0, 0])
    }

    // MARK: - Helpers

    private func stopAllAnimations() {
        cancelPendingFirstFrame()
        stopCompletionPolling()

        playbackControllers.forEach { $0.stop() }
        playbackControllers.removeAll()
    }
}
