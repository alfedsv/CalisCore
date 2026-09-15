//
//  WorkoutViewController.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            viewModel.back()
        }
    }

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
        
        viewModel.onNext = { [weak self] workoutModel in
            let viewController = WorkoutViewController(workoutModel: workoutModel)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        
        viewModel.onFinish = { [weak self] in
            let viewController = FinishViewController()
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        titleExerciseLabel.text = "exercise.title".localized + " " + String(viewModel.exerciseNumber) + " / " + String(viewModel.exercisesCount)
        contentView.addSubview(titleExerciseLabel)
        contentView.addSubview(sceneView)
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
        playExercise(animationName: "idle")
    }
    
    private func setupScene() {
        sceneView.scene = SCNScene()
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = .clear
    }
    
    private func playExercise(animationName: String) {
        guard let url = Bundle.main.url(forResource: animationName, withExtension: "dae") else {
            print("Файл \(animationName).dae не найден")
            return
        }
        let source = SCNSceneSource(url: url, options: nil)
        guard let scene = source?.scene(options: nil) else {
            print("Не удалось загрузить сцену из \(animationName).dae")
            return
        }
        var found = false
        scene.rootNode.enumerateChildNodes { node, _ in
            for key in node.animationKeys {
                if let player = node.animationPlayer(forKey: key) {
                    player.animation.repeatCount = CGFloat.greatestFiniteMagnitude
                    player.animation.isCumulative = false
                    player.play()
                    found = true
                }
            }
        }
        if !found, !scene.rootNode.animationKeys.isEmpty {
            for key in scene.rootNode.animationKeys {
                scene.rootNode.animationPlayer(forKey: key)?.play()
            }
        }
        scene.rootNode.childNodes.filter { $0.camera != nil }.forEach { $0.removeFromParentNode() }
        let bbox = scene.rootNode.boundingBox
        let modelHeight = bbox.max.y - bbox.min.y
        let desiredHeight: Float = 2.0
        if modelHeight > 0 {
            let scale = desiredHeight / modelHeight
            scene.rootNode.scale = SCNVector3(scale, scale, scale)
        }
        let center = scene.rootNode.boundingSphere.center
        let radius = scene.rootNode.boundingSphere.radius
        let scaledCenter = SCNVector3(
            center.x * scene.rootNode.scale.x,
            center.y * scene.rootNode.scale.y,
            center.z * scene.rootNode.scale.z
        )
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zNear = 0.01
        cameraNode.camera?.zFar  = 1000
        cameraNode.camera?.fieldOfView = 45
        let radiusOrbit: Float = radius * 3.5   // расстояние до центра (как далеко)
        let azimuth: Float  = .pi / 8           // насколько «сбоку» (0 — прямо, ±π/2 — строго сбоку)
        let elevation: Float = .pi / 4         // насколько сверху (0 — по центру, π/2 — строго сверху)
        let x = radiusOrbit * cos(elevation) * sin(azimuth)
        let y = radiusOrbit * sin(elevation)
        let z = radiusOrbit * cos(elevation) * cos(azimuth)
        cameraNode.position = SCNVector3(
            scaledCenter.x + x,
            scaledCenter.y + y,
            scaledCenter.z + z
        )
        cameraNode.look(at: SCNVector3(
            scaledCenter.x,
            scaledCenter.y + radius * 0.4,
            scaledCenter.z
        ))
        scene.rootNode.addChildNode(cameraNode)
        sceneView.scene = scene
        sceneView.pointOfView = cameraNode
    }
    
    private func setupCamera() {
        
    }
    
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
            
            sceneView.topAnchor.constraint(equalTo: titleExerciseLabel.bottomAnchor, constant: 25),
            sceneView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sceneView.heightAnchor.constraint(equalToConstant: AppConstants.Layout.imageLargeSide),
            sceneView.widthAnchor.constraint(equalTo: sceneView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: sceneView.bottomAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),

            setsCountLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
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
            
            controlButton.topAnchor.constraint(equalTo: durationRestLabel.bottomAnchor, constant: 40),
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
