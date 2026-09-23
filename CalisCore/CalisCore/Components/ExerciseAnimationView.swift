//
//  ExerciseAnimationView.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 17.09.2026.
//

import UIKit
import SceneKit


final class ExerciseAnimationView: UIView {

    // MARK: - Private UI

    private let sceneView = SCNView()

    // MARK: - Scene graph

    private lazy var pivotNode: SCNNode = {
        let node = SCNNode()
        return node
    }()
    
    private lazy var cameraNode: SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.camera?.zNear = 0.01
        node.camera?.zFar = 1000
        node.camera?.fieldOfView = 45
        return node
    }()

    private lazy var containerScene: SCNScene = {
        let scene = SCNScene()
        pivotNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(pivotNode)
        return scene
    }()

    private var currentModelRoot: SCNNode?

    // MARK: - State

    private var persistentScale: Float?
    private var hasSetUpCamera = false
    private var transitionToken = UUID()
    
    /// Текущая проигрываемая сцена — нужна для пересчёта камеры при вращении.
    private var currentSceneModel: SceneModel?
    /// Радиус и центр модели в мировых координатах (для пересчёта камеры).
    private var currentScaledCenter: SCNVector3 = SCNVector3Zero
    private var currentScaledRadius: Float = 0
    /// Текущий дополнительный поворот камеры (радианы), задаваемый слайдером.
    private var cameraAzimuthOffset: Float = 0

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        sceneView.scene = containerScene
        sceneView.pointOfView = cameraNode
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = false
        sceneView.backgroundColor = .clear
        sceneView.rendersContinuously = true
        sceneView.isPlaying = true
        addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Reset

    /// Полный сброс внутреннего состояния.
    /// Вызывать, если вью переиспользуется для нового упражнения.
    /// Кеш сцен при этом сохраняется.
    func reset() {
        transitionToken = UUID()
        currentModelRoot?.removeAllActions()
        currentModelRoot?.enumerateChildNodes { node, _ in
            node.removeAllActions()
        }
        currentModelRoot?.removeFromParentNode()
        currentModelRoot = nil
        persistentScale = nil
        hasSetUpCamera = false
        currentSceneModel = nil
        currentScaledCenter = SCNVector3Zero
        currentScaledRadius = 0
        cameraAzimuthOffset = 0
    }

    // MARK: - Preload

    /// Предзагрузка сцен в кеш.
    func preload(scenes: [SceneModel], completion: (() -> Void)? = nil) {
        let names = Set(scenes.map(\.name))
        ExerciseSceneCache.shared.preload(names: names, completion: completion)
    }

    // MARK: - Play

    /// Проигрывает сцену. `loop = true` — бесконечно, `loop = false` — один раз,
    /// после чего вызовется `completion` (если передан).
    func play(scene exerciseScene: SceneModel, alternating: Bool = false, loop: Bool = true, completion: (() -> Void)? = nil) {
        let token = UUID()
        transitionToken = token

        guard let wrapper = instantiateModel(named: exerciseScene.name) else {
            // Кеша нет — сразу завершаем, чтобы не залипнуть в .transition
            DispatchQueue.main.async { [weak self] in
                guard let self = self, self.transitionToken == token else { return }
                completion?()
            }
            return
        }

        // Масштаб фиксируем по первой сцене
        if persistentScale == nil {
            let bbox = wrapper.boundingBox
            let modelHeight = bbox.max.y - bbox.min.y
            let desiredHeight: Float = 2.0
            persistentScale = modelHeight > 0 ? desiredHeight / modelHeight : 1.0
        }
        let scale = persistentScale!
        wrapper.scale = SCNVector3(scale, scale, scale)

        // Сразу прячем — чтобы не мелькнул bind pose
        wrapper.isHidden = true

        // Запускаем анимации ДО добавления в граф
        var maxDuration: TimeInterval = 0
        var found = false

        wrapper.enumerateChildNodes { node, _ in
            for key in node.animationKeys {
                guard let player = node.animationPlayer(forKey: key) else { continue }
                player.animation.repeatCount = loop ? .greatestFiniteMagnitude : 1
                player.animation.autoreverses = alternating
                player.animation.isCumulative = false
                player.animation.isRemovedOnCompletion = false
                player.play()
                maxDuration = max(maxDuration, player.animation.duration)
                found = true
            }
        }
        if !found, !wrapper.animationKeys.isEmpty {
            for key in wrapper.animationKeys {
                guard let player = wrapper.animationPlayer(forKey: key) else { continue }
                player.animation.repeatCount = loop ? .greatestFiniteMagnitude : 1
                player.animation.autoreverses = alternating
                player.animation.isCumulative = false
                player.animation.isRemovedOnCompletion = false
                player.play()
                maxDuration = max(maxDuration, player.animation.duration)
            }
        }

        // Геометрия модели — в мировых координатах
        let center = wrapper.boundingSphere.center
        let radius = wrapper.boundingSphere.radius
        let scaledCenter = SCNVector3(center.x * scale, center.y * scale, center.z * scale)
        let scaledRadius = radius * scale

        // Сохраняем данные сцены для пересчёта камеры при вращении слайдером
        currentSceneModel = exerciseScene
        currentScaledCenter = scaledCenter
        currentScaledRadius = scaledRadius

        // Атомарная подмена старой модели на новую
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0
        SCNTransaction.disableActions = true

        if let old = currentModelRoot {
            old.removeAllActions()
            old.enumerateChildNodes { node, _ in node.removeAllActions() }
            old.removeFromParentNode()
        }
        containerScene.rootNode.addChildNode(wrapper)
        currentModelRoot = wrapper

        SCNTransaction.commit()

        // Камера: первый раз — мгновенно, дальше — плавно.
        // Всю математику орбиты делает updateCameraPosition (pivot + camera внутри pivot).
        if !hasSetUpCamera {
            hasSetUpCamera = true
            updateCameraPosition(animated: false)
        } else {
            updateCameraPosition(animated: true)
        }

        // Показываем узел — анимация уже применена
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0
        SCNTransaction.disableActions = true
        wrapper.isHidden = false
        SCNTransaction.commit()

        // Completion — привязан к рендер-циклу через SCNAction
        guard let completion = completion else { return }

        if maxDuration > 0 {
            let wait = SCNAction.wait(duration: maxDuration)
            let fire = SCNAction.run { [weak self] _ in
                guard let self = self, self.transitionToken == token else { return }
                completion()
            }
            wrapper.runAction(.sequence([wait, fire]), forKey: "completion")
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self, self.transitionToken == token else { return }
                completion()
            }
        }
    }

    // MARK: - Model instantiation

    /// Достаёт сцену из кеша, клонирует, убирает камеры и оборачивает в wrapper-узел.
    private func instantiateModel(named name: String) -> SCNNode? {
        guard let cachedScene = ExerciseSceneCache.shared.scene(named: name) else {
            print("Сцена \(name) отсутствует в кеше")
            return nil
        }

        let clonedRoot = cachedScene.rootNode.clone()

        clonedRoot.childNodes
            .filter { $0.camera != nil }
            .forEach { $0.removeFromParentNode() }

        let wrapper = SCNNode()
        for child in clonedRoot.childNodes {
            wrapper.addChildNode(child)
        }
        return wrapper
    }
    
    // MARK: - Rendering control

    /// Останавливает рендер-луп SCNView, не трогая анимации и модели.
    /// Вызывать, когда вью полностью ушла с экрана.
    func pauseRendering() {
        sceneView.isPlaying = false
    }

    /// Возобновляет рендер-луп.
    func resumeRendering() {
        sceneView.isPlaying = true
    }
    
    // MARK: - Camera orbit

    /// Устанавливает дополнительный поворот камеры вокруг вертикальной оси.
    /// - Parameter azimuthOffset: смещение в радианах (например, от -π до +π).
    func setCameraAzimuthOffset(_ azimuthOffset: Float) {
        cameraAzimuthOffset = azimuthOffset
        updateCameraPosition(animated: false)
    }

    /// Сбрасывает дополнительный поворот камеры.
    func resetCameraAzimuthOffset() {
        cameraAzimuthOffset = 0
        updateCameraPosition(animated: false)
    }

    /// Пересчитывает позицию камеры с учётом текущего азимута.
    private func updateCameraPosition(animated: Bool) {
        guard let scene = currentSceneModel else { return }

        let effectiveAzimuth = scene.azimuth + cameraAzimuthOffset

        // Пивот ставим в точку, куда должна смотреть камера
        let lookAtTarget = SCNVector3(
            currentScaledCenter.x + currentScaledRadius * scene.scaledCenterMulX,
            currentScaledCenter.y + currentScaledRadius * scene.scaledCenterMulY,
            currentScaledCenter.z + currentScaledRadius * scene.scaledCenterMulZ
        )
        let radiusOrbit = currentScaledRadius * scene.radiusOrbitMul
        let elevation = scene.elevation

        let apply: () -> Void = { [weak self] in
            guard let self = self else { return }

            // Пивот — в цель, вращаем вокруг Y
            self.pivotNode.position = lookAtTarget
            self.pivotNode.eulerAngles = SCNVector3(0, effectiveAzimuth, 0)

            // Камера внутри пивота: отходим назад и вверх по локальным осям
            let localX: Float = 0
            let localY: Float = radiusOrbit * sin(elevation)
            let localZ: Float = radiusOrbit * cos(elevation)
            self.cameraNode.position = SCNVector3(localX, localY, localZ)

            // Смотрим ровно в начало пивота — без крена, без look(at:) на мировые точки
            self.cameraNode.eulerAngles = SCNVector3(-elevation, 0, 0)
        }

        SCNTransaction.begin()
        if animated {
            SCNTransaction.animationDuration = 0.15
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        } else {
            SCNTransaction.animationDuration = 0
            SCNTransaction.disableActions = true
        }
        apply()
        SCNTransaction.commit()
    }
}
