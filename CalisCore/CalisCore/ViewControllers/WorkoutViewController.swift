//
//  WorkoutViewController.swift
//  CalisCore
//
//  Created by Alexander Fedoseev on 15.09.2026.
//

import UIKit
import SceneKit

final class WorkoutViewController: UIViewController {

    private let viewModel: WorkoutViewModelProtocol

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleExerciseLabel = MainTitleLabel()
    private let sceneView: SCNView = SCNView()

    private let titleLabel = TitleLabel()
    private let descriptionLabel = DescriptionLabel()

    private let setsCountLabel = DescriptionExerciseLabel()
    private let durationSetsLabel = DescriptionExerciseLabel()
    private let durationRestLabel = DescriptionExerciseLabel()
    private let setsCountNumberLabel = DescriptionExerciseLabel()
    private let durationSetsNumberLabel = DescriptionExerciseLabel()
    private let durationRestNumberLabel = DescriptionExerciseLabel()

    private let controlButton = ControlLargeButton()
    private var progressViews: [UIProgressView] = []

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        return stackView
    }()

    private let nextButton = LargeButton(title: "largeButton.next".localized)

    private var transitionToken = UUID()
    private var pendingTarget: CurrentPhase?

    private var persistentScale: Float?
    private var hasSetUpCamera = false

    /// Кеш заранее загруженных сцен из .dae
    private var sceneCache: [String: SCNScene] = [:]
    private var isPreloading = false

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
        scene.rootNode.addChildNode(cameraNode)
        return scene
    }()

    private var currentModelRoot: SCNNode?

    init(workoutModel: WorkoutModel) {
        self.viewModel = WorkoutViewModel(workoutModel: workoutModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()

        preloadScenes { [weak self] in
            self?.playLoop(for: .idle)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            viewModel.back()
        }
    }

    // MARK: - Preload

    private func preloadScenes(completion: (() -> Void)? = nil) {
        guard !isPreloading else { return }
        isPreloading = true

        let scenes = viewModel.exerciseModel.exerciseScenes
        let names = Set([
            scenes.idle.name,
            scenes.workoutScene.name,
            scenes.idleToWorkoutScene.name,
            scenes.workoutToIdleScene.name
        ])

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            var loaded: [String: SCNScene] = [:]
            for name in names {
                guard let url = Bundle.main.url(forResource: name, withExtension: "dae"),
                      let scene = SCNSceneSource(url: url, options: nil)?.scene(options: nil)
                else {
                    print("Не удалось предзагрузить сцену \(name)")
                    continue
                }
                loaded[name] = scene
            }
            DispatchQueue.main.async {
                self?.sceneCache = loaded
                self?.isPreloading = false
                completion?()
            }
        }
    }

    // MARK: - Bind

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.updateProgressBars()
        }

        viewModel.onStarted = { [weak self] in
            self?.controlButton.currentState = .running
        }

        viewModel.onStoped = { [weak self] in
            self?.controlButton.currentState = .stopped
        }

        viewModel.onEnded = { [weak self] in
            self?.controlButton.currentState = .ended
        }

        viewModel.onPhaseChanged = { [weak self] phase in
            self?.handleTargetPhase(phase)
        }

        viewModel.onNext = { [weak self] workoutModel in
            let viewController = WorkoutViewController(workoutModel: workoutModel)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }

        viewModel.onFinish = { [weak self] in
            let viewController = FinishViewController()
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    // MARK: - UI setup

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        titleExerciseLabel.text = "exercise.title".localized + " " + String(viewModel.exerciseNumber) + " / " + String(viewModel.exercisesCount)
        contentView.addSubview(titleExerciseLabel)
        contentView.addSubview(sceneView)
        sceneView.layer.borderWidth = 1 //tmp
        sceneView.layer.borderColor = UIColor.black.cgColor //tmp
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(setsCountLabel)
        contentView.addSubview(setsCountNumberLabel)
        contentView.addSubview(durationSetsLabel)
        contentView.addSubview(durationSetsNumberLabel)
        contentView.addSubview(durationRestLabel)
        contentView.addSubview(durationRestNumberLabel)

        setupScene()
        titleLabel.text = viewModel.exerciseModel.title
        descriptionLabel.text = viewModel.exerciseModel.description
        setsCountLabel.text = "exercise.setsCount".localized
        setsCountNumberLabel.text = String(viewModel.exerciseModel.setsCount)
        durationSetsLabel.text = "exercise.durationSets".localized
        durationSetsNumberLabel.text = String(viewModel.exerciseModel.setDuration) + " " + "exercise.secunds".localized
        durationRestLabel.text = "exercise.durationRest".localized
        durationRestNumberLabel.text = String(viewModel.exerciseModel.recoveryDuration) + " " + "exercise.secunds".localized
        setsCountLabel.setContentHuggingPriority(.required, for: .horizontal)
        setsCountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        durationSetsLabel.setContentHuggingPriority(.required, for: .horizontal)
        durationSetsLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        durationRestLabel.setContentHuggingPriority(.required, for: .horizontal)
        durationRestLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        contentView.addSubview(controlButton)
        controlButton.currentState = viewModel.exerciseModel.currentState
        controlButton.addTarget(self, action: #selector(controlButtonTapped), for: .touchUpInside)
        contentView.addSubview(stackView)

        for _ in 0..<viewModel.exerciseModel.setsCount {
            let (setContainer, setProgress) = createStepContainer(title: "Подход", progress: 0.0, tintColor: UIColor(named: AppConstants.Colors.progressBarSet))
            stackView.addArrangedSubview(setContainer)
            progressViews.append(setProgress)

            let (restContainer, restProgress) = createStepContainer(title: "Отдых", progress: 0.0, tintColor: UIColor(named: AppConstants.Colors.progressBarRest))
            stackView.addArrangedSubview(restContainer)
            progressViews.append(restProgress)
        }

        contentView.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        setupConstraints()
        updateProgressBars()
    }

    private func setupScene() {
        sceneView.scene = containerScene
        sceneView.pointOfView = cameraNode
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = .clear
        sceneView.rendersContinuously = true
        sceneView.isPlaying = true
    }

    // MARK: - Phase handling

    private func handleTargetPhase(_ target: CurrentPhase) {
        let model = viewModel.exerciseModel
        if model.currentPhase == target { return }
        if model.currentPhase == .transition {
            pendingTarget = target
            return
        }
        startTransition(to: target)
    }

    private func startTransition(to target: CurrentPhase) {
        let model = viewModel.exerciseModel
        let scenes = model.exerciseScenes
        let transitionScene = (model.currentPhase == .idle) ? scenes.idleToWorkoutScene : scenes.workoutToIdleScene
        model.currentPhase = .transition
        pendingTarget = target
        playExercise(exerciseScene: transitionScene, loop: false) { [weak self] in
            guard let self = self else { return }
            let next = self.pendingTarget ?? target
            self.pendingTarget = nil
            self.viewModel.exerciseModel.currentPhase = next
            self.playLoop(for: next)
        }
    }

    private func playLoop(for phase: CurrentPhase) {
        let scenes = viewModel.exerciseModel.exerciseScenes
        let scene = (phase == .workout) ? scenes.workoutScene : scenes.idle
        playExercise(exerciseScene: scene, loop: true)
    }

    // MARK: - Play exercise

    private func playExercise(exerciseScene: SceneModel, loop: Bool = true, completion: (() -> Void)? = nil) {
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
                player.animation.isCumulative = false
                player.animation.isRemovedOnCompletion = false
                player.play()
                maxDuration = max(maxDuration, player.animation.duration)
            }
        }

        // Геометрия для камеры — в мировых координатах
        let center = wrapper.boundingSphere.center
        let radius = wrapper.boundingSphere.radius
        let scaledCenter = SCNVector3(center.x * scale, center.y * scale, center.z * scale)
        let scaledRadius = radius * scale

        let radiusOrbit: Float = scaledRadius * exerciseScene.radiusOrbitMul
        let x = radiusOrbit * cos(exerciseScene.elevation) * sin(exerciseScene.azimuth)
        let y = radiusOrbit * sin(exerciseScene.elevation)
        let z = radiusOrbit * cos(exerciseScene.elevation) * cos(exerciseScene.azimuth)

        let targetPosition = SCNVector3(scaledCenter.x + x, scaledCenter.y + y, scaledCenter.z + z)
        let lookAtTarget = SCNVector3(
            scaledCenter.x + scaledRadius * exerciseScene.scaledCenterMulX,
            scaledCenter.y + scaledRadius * exerciseScene.scaledCenterMulY,
            scaledCenter.z + scaledRadius * exerciseScene.scaledCenterMulZ
        )

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

        // Камера: первый раз — мгновенно, дальше — плавно
        if !hasSetUpCamera {
            hasSetUpCamera = true
            cameraNode.position = targetPosition
            cameraNode.look(at: lookAtTarget)
        } else {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.35
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            cameraNode.position = targetPosition
            cameraNode.look(at: lookAtTarget)
            SCNTransaction.commit()
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
        guard let cachedScene = sceneCache[name] else {
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

    // MARK: - Progress helpers

    private func createStepContainer(title: String, progress: Float, tintColor: UIColor?) -> (UIStackView, UIProgressView) {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 8
        container.alignment = .center
        container.distribution = .fill

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(named: AppConstants.Colors.labelText)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.widthAnchor.constraint(equalToConstant: 55).isActive = true
        container.addArrangedSubview(label)

        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = progress
        progressView.tintColor = tintColor
        progressView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        container.addArrangedSubview(progressView)

        return (container, progressView)
    }

    private func updateProgressBars() {
        guard !progressViews.isEmpty else { return }

        let currentProgress = viewModel.exerciseModel.progress

        var durations: [Int] = []
        for _ in 0..<viewModel.exerciseModel.setsCount {
            durations.append(viewModel.exerciseModel.setDuration)
            durations.append(viewModel.exerciseModel.recoveryDuration)
        }

        guard progressViews.count == durations.count else { return }

        var accumulated = 0
        for (index, duration) in durations.enumerated() {
            let progressView = progressViews[index]
            if currentProgress >= accumulated + duration {
                progressView.progress = 1.0
            } else if currentProgress > accumulated {
                let fraction = Float(currentProgress - accumulated) / Float(duration)
                progressView.progress = min(fraction, 1.0)
            } else {
                progressView.progress = 0.0
            }
            accumulated += duration
        }
    }

    @objc
    private func controlButtonTapped() {
        viewModel.control()
    }

    @objc
    private func nextButtonTapped() {
        viewModel.next()
    }
}

extension WorkoutViewController {
    private func setupConstraints() {
        [
            scrollView,
            contentView,
            titleExerciseLabel,
            sceneView,
            titleLabel,
            descriptionLabel,
            setsCountLabel,
            setsCountNumberLabel,
            durationSetsLabel,
            durationSetsNumberLabel,
            durationRestLabel,
            durationRestNumberLabel,
            controlButton,
            stackView,
            nextButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            titleExerciseLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleExerciseLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleExerciseLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            

            titleLabel.topAnchor.constraint(equalTo: titleExerciseLabel.bottomAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),

            setsCountLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 25),
            setsCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),

            setsCountNumberLabel.leadingAnchor.constraint(equalTo: setsCountLabel.trailingAnchor, constant: 5),
            setsCountNumberLabel.centerYAnchor.constraint(equalTo: setsCountLabel.centerYAnchor),
            setsCountNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),

            durationSetsLabel.topAnchor.constraint(equalTo: setsCountLabel.bottomAnchor, constant: 8),
            durationSetsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),

            durationSetsNumberLabel.leadingAnchor.constraint(equalTo: durationSetsLabel.trailingAnchor, constant: 5),
            durationSetsNumberLabel.centerYAnchor.constraint(equalTo: durationSetsLabel.centerYAnchor),
            durationSetsNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),

            durationRestLabel.topAnchor.constraint(equalTo: durationSetsLabel.bottomAnchor, constant: 8),
            durationRestLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),

            durationRestNumberLabel.leadingAnchor.constraint(equalTo: durationRestLabel.trailingAnchor, constant: 5),
            durationRestNumberLabel.centerYAnchor.constraint(equalTo: durationRestLabel.centerYAnchor),
            durationRestNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            sceneView.topAnchor.constraint(equalTo: durationRestLabel.bottomAnchor, constant: 25),
            sceneView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sceneView.heightAnchor.constraint(equalToConstant: AppConstants.Layout.imageLargeSide),
            sceneView.widthAnchor.constraint(equalTo: sceneView.heightAnchor),

            controlButton.topAnchor.constraint(equalTo: sceneView.bottomAnchor, constant: 40),
            controlButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            controlButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            controlButton.heightAnchor.constraint(equalToConstant: 30),

            stackView.topAnchor.constraint(equalTo: controlButton.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            nextButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 65),
            nextButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppConstants.Layout.paddingLargeButton),
            nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppConstants.Layout.paddingLargeButton),
            nextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppConstants.Layout.paddingLargeButtonBottom),
            nextButton.heightAnchor.constraint(equalToConstant: AppConstants.Layout.buttonHeightStandard)
        ])
    }
}
