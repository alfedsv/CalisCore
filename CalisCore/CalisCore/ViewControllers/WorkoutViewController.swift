//
//  WorkoutViewController.swift
//  CalisCore
//
//  Created by Alexander Fedoseev on 15.09.2026.
//


import UIKit

/// Контроллер экрана выполнения упражнения.
/// Управляет анимацией, прогресс-барами и переходами между фазами.
final class WorkoutViewController: UIViewController {

    // MARK: - Dependencies

    private let viewModel: WorkoutViewModelProtocol

    // MARK: - UI Elements

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleExerciseLabel = MainTitleLabel()
    private let animationView = ExerciseAnimationView()
    private let titleLabel = TitleLabel()
    private let descriptionButton = DescriptionButton()
    private let setsCountLabel = DescriptionExerciseLabel()
    private let durationSetsLabel = DescriptionExerciseLabel()
    private let durationRestLabel = DescriptionExerciseLabel()
    private let setsCountNumberLabel = DescriptionExerciseLabel()
    private let durationSetsNumberLabel = DescriptionExerciseLabel()
    private let durationRestNumberLabel = DescriptionExerciseLabel()
    private let controlButton = ControlLargeButton()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        return stackView
    }()
    private let nextButton = LargeButton(title: "largeButton.next".localized, isActive: true)

    // MARK: - State

    private var progressViews: [UIProgressView] = []
    private var pendingTarget: CurrentPhase?

    // MARK: - Init

    init(workoutModel: WorkoutModel) {
        self.viewModel = WorkoutViewModel(workoutModel: workoutModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.resumeRendering()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            viewModel.back()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationView.pauseRendering()
    }

    // MARK: - Binding

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.updateProgressBars()
        }

        viewModel.onStarted = { [weak self] in
            self?.controlButton.currentState = .running
        }

        viewModel.onStopped = { [weak self] in
            self?.controlButton.currentState = .stopped
        }

        viewModel.onEnded = { [weak self] in
            self?.controlButton.currentState = .ended
        }

        viewModel.onPhaseChanged = { [weak self] phase in
            self?.handleTargetPhase(phase)
        }

        viewModel.onToDescription = { [weak self] title, description in
            let vc = DescriptionViewController(title: title, description: description)
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 24
            }
            self?.present(vc, animated: true)
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

    // MARK: - Setup UI

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        titleExerciseLabel.text = "exercise.title".localized + " " + String(viewModel.exerciseNumber) + " / " + String(viewModel.exercisesCount)
        contentView.addSubview(titleExerciseLabel)
        contentView.addSubview(animationView)

        // TODO: убрать border после отладки камеры
        animationView.layer.borderWidth = 1
        animationView.layer.borderColor = UIColor.black.cgColor
        
        let scenes = viewModel.exerciseModel.exerciseScenes
        var toPreload: [SceneModel] = [scenes.idle, scenes.workoutScene]
        if let s = scenes.idleToWorkoutScene { toPreload.append(s) }
        if let s = scenes.workoutToIdleScene { toPreload.append(s) }

        animationView.preload(scenes: toPreload) { [weak self] in
            self?.playLoop(for: .idle)
        }

        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionButton)
        descriptionButton.addTarget(self, action: #selector(descriptionButtonTapped), for: .touchUpInside)
        contentView.addSubview(setsCountLabel)
        contentView.addSubview(setsCountNumberLabel)
        contentView.addSubview(durationSetsLabel)
        contentView.addSubview(durationSetsNumberLabel)
        contentView.addSubview(durationRestLabel)
        contentView.addSubview(durationRestNumberLabel)

        titleLabel.text = viewModel.exerciseModel.title
        setsCountLabel.text = "exercise.setsCount".localized
        setsCountNumberLabel.text = String(viewModel.exerciseModel.setsCount)
        durationSetsLabel.text = "exercise.durationSets".localized
        durationSetsNumberLabel.text = String(viewModel.exerciseModel.setDuration) + " " + "exercise.seconds".localized
        durationRestLabel.text = "exercise.durationRest".localized
        durationRestNumberLabel.text = String(viewModel.exerciseModel.recoveryDuration) + " " + "exercise.seconds".localized
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
        setupProgressViews()
        contentView.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        setupConstraints()
        updateProgressBars()
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
        let goingToWorkout = (model.currentPhase == .idle)
        let transitionScene = goingToWorkout ? scenes.idleToWorkoutScene : scenes.workoutToIdleScene
        // Нет переходного клипа — переключаемся мгновенно
        guard let transitionScene = transitionScene else {
            model.currentPhase = target
            pendingTarget = nil
            playLoop(for: target)
            return
        }
        model.currentPhase = .transition
        pendingTarget = target
        animationView.play(scene: transitionScene, loop: false) { [weak self] in
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
        let alternating = (phase == .workout) && scenes.isWorkoutReversed
        animationView.play(scene: scene, alternating: alternating, loop: true)
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

    private func setupProgressViews() {
        progressViews = []
        for step in viewModel.exerciseModel.steps {
            let (title, color) = presentation(kind: step.kind)
            let (container, progress) = createStepContainer(title: title, progress: 0, tintColor: color)
            stackView.addArrangedSubview(container)
            progressViews.append(progress)
        }
    }

    private func presentation(kind: ExerciseStepKindModel) -> (String, UIColor?) {
        switch kind {
        case .setDuration:
            return ("exercise.label.set".localized, UIColor(named: AppConstants.Colors.progressBarSet))
        case .restDuration, .circuitRestDuration:
            return ("exercise.label.rest".localized, UIColor(named: AppConstants.Colors.progressBarRest))
        }
    }

    private func updateProgressBars() {
        let model = viewModel.exerciseModel
        let steps = model.steps
        guard progressViews.count == steps.count else { return }
        var accumulated = 0
        for (index, step) in steps.enumerated() {
            let progressView = progressViews[index]
            let p = model.progress
            if p >= accumulated + step.duration {
                progressView.progress = 1
            } else if p > accumulated {
                progressView.progress = Float(p - accumulated) / Float(step.duration)
            } else {
                progressView.progress = 0
            }
            accumulated += step.duration
        }
    }

    // MARK: - Actions

    @objc
    private func controlButtonTapped() {
        viewModel.control()
    }

    @objc
    private func nextButtonTapped() {
        viewModel.next()
    }
    
    @objc
    private func descriptionButtonTapped() {
        viewModel.toDescription()
    }
}

// MARK: - Layout

private extension WorkoutViewController {
    func setupConstraints() {
        [
            scrollView,
            contentView,
            titleExerciseLabel,
            animationView,
            titleLabel,
            descriptionButton,
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

            descriptionButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionButton.heightAnchor.constraint(equalToConstant: AppConstants.Layout.buttonHeightSmoll),

            setsCountLabel.topAnchor.constraint(equalTo: descriptionButton.bottomAnchor, constant: 20),
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

            animationView.topAnchor.constraint(equalTo: durationRestLabel.bottomAnchor, constant: 15),
            animationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppConstants.Layout.animationViewPadding),
            animationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -AppConstants.Layout.animationViewPadding),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor),

            controlButton.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 20),
            controlButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            controlButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            controlButton.heightAnchor.constraint(equalToConstant: AppConstants.Layout.buttonHeightSmoll),

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
