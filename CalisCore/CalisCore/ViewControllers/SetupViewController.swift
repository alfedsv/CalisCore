//
//  SetupViewController.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import UIKit

/// Контроллер экрана настройки тренировки.
/// Позволяет выбрать длительность и количество упражнений.
final class SetupViewController: UIViewController {

    // MARK: - Dependencies

    private let viewModel: SetupViewModelProtocol

    // MARK: - UI Elements

    private let durationSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = Float(WorkoutModelConstants.workoutDurationMin)
        slider.maximumValue = Float(WorkoutModelConstants.workoutDurationMax)
        slider.isContinuous = true
        slider.minimumTrackTintColor = UIColor(named: AppConstants.Colors.sliderActive)
        slider.maximumTrackTintColor = UIColor(named: AppConstants.Colors.sliderUnactive)
        return slider
    }()
    private let exercisesSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = Float(WorkoutModelConstants.exercisesCountMin)
        slider.maximumValue = Float(DataSource.exercises.count)
        slider.isContinuous = true
        slider.minimumTrackTintColor = UIColor(named: AppConstants.Colors.sliderActive)
        slider.maximumTrackTintColor = UIColor(named: AppConstants.Colors.sliderUnactive)
        return slider
    }()
    private let durationTitleLabel = MainTitleLabel(text: "setupTitle.duration".localized)
    private let exercisesTitleLabel = MainTitleLabel(text: "setupTitle.exercisesCount".localized)
    private let durationValueLabel = DescriptionLabel()
    private let exercisesValueLabel = DescriptionLabel()
    private let workoutTypeTitleLabel = MainTitleLabel(text: "setupTitle.targetArea".localized)
    private var workoutTypeButtons: [SetupButton] = []
    private let workoutTypeGrid: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = AppConstants.Layout.workoutTypeSpacing
        return stack
    }()
    private let recomendationView: RecomendationView = RecomendationView(workoutType: WorkoutType.default)
    private let nextButton = LargeButton(title: "largeButton.begin".localized, isActive: true)
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(named: AppConstants.Colors.labelText)
        label.numberOfLines = 1
        label.textAlignment = .center
        let version = Bundle.main.appVersion
        let build = Bundle.main.appBuild
        label.text = "version".localized + " \(version) (\(build))"
        return label
    }()

    // MARK: - Init

    init() {
        self.viewModel = SetupViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupValues()
        bindViewModel()
    }

    // MARK: - Binding

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.setupValues()
        }
        
        viewModel.onUpdateWorkoutType = { [weak self] workoutType in
            guard let self = self else { return }
            self.recomendationView.setupAppearance(workoutType: workoutType)
            for button in workoutTypeButtons {
                button.isSelected = (button.workoutType == workoutType)
            }
        }
        
        viewModel.onNext = { [weak self] workoutModel in
            let viewController = WorkoutViewController(workoutModel: workoutModel)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    // MARK: - Setup UI

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(workoutTypeGrid)
        view.addSubview(workoutTypeTitleLabel)
        setupWorkoutTypeButtons()
        view.addSubview(durationTitleLabel)
        view.addSubview(durationSlider)
        view.addSubview(durationValueLabel)
        view.addSubview(exercisesTitleLabel)
        view.addSubview(exercisesSlider)
        view.addSubview(exercisesValueLabel)
        view.addSubview(recomendationView)
        view.addSubview(nextButton)
        view.addSubview(versionLabel)
        setupConstraints()
    }
    
    // MARK: - Workout type buttons

    private func setupWorkoutTypeButtons() {
        let workoutTypes: [WorkoutType] = [.strength, .endurance, .explosivePower, .circuit]
        workoutTypeButtons = workoutTypes.enumerated().map { index, workoutType in
            let button = SetupButton(workoutType: workoutType)
            button.tag = index
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: AppConstants.Layout.buttonHeightSmoll).isActive = true
            button.addTarget(self, action: #selector(workoutTypeButtonTapped(_:)), for: .touchUpInside)
            button.isSelected = (button.workoutType == WorkoutType.default)
            return button
        }
        let row1 = UIStackView(arrangedSubviews: [workoutTypeButtons[0], workoutTypeButtons[1]])
        let row2 = UIStackView(arrangedSubviews: [workoutTypeButtons[2], workoutTypeButtons[3]])
        [row1, row2].forEach {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.spacing = AppConstants.Layout.workoutTypeSpacing
        }
        workoutTypeGrid.addArrangedSubview(row1)
        workoutTypeGrid.addArrangedSubview(row2)
    }
    
    private func setupActions() {
        durationSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        exercisesSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    private func setupValues() {
        durationSlider.value = Float(viewModel.workoutDurationMinutes)
        exercisesSlider.value = Float(viewModel.exercisesCount)
        durationValueLabel.text = String(viewModel.workoutDurationMinutes) + " " + "slider.minutes".localized
        exercisesValueLabel.text = String(viewModel.exercisesCount) + " " + "slider.variants".localized
    }

    // MARK: - Actions

    @objc
    private func sliderValueChanged(_ slider: UISlider) {
        let rounded = round(slider.value)
        slider.value = rounded
        let intValue = Int(slider.value)
        if slider == durationSlider {
            viewModel.workoutDurationUpdate(minutes: intValue)
        } else if slider == exercisesSlider {
            viewModel.exercisesCountUpdate(count: intValue)
        }
    }

    @objc
    private func workoutTypeButtonTapped(_ sender: SetupButton) {
        viewModel.select(workoutType: sender.workoutType)
    }

    @objc
    private func nextButtonTapped() {
        viewModel.next()
    }
}

// MARK: - Layout

private extension SetupViewController {
    func setupConstraints() {
        [
            workoutTypeTitleLabel,
            workoutTypeGrid,
            durationTitleLabel,
            durationSlider,
            durationValueLabel,
            exercisesTitleLabel,
            exercisesSlider,
            exercisesValueLabel,
            recomendationView,
            nextButton,
            versionLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            workoutTypeTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            workoutTypeTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            workoutTypeTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            workoutTypeGrid.topAnchor.constraint(equalTo: workoutTypeTitleLabel.bottomAnchor, constant: 20),
            workoutTypeGrid.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            workoutTypeGrid.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            durationTitleLabel.topAnchor.constraint(equalTo: workoutTypeGrid.bottomAnchor, constant: 30),
            durationTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            durationTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            durationSlider.topAnchor.constraint(equalTo: durationTitleLabel.bottomAnchor, constant: 8),
            durationSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            durationSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            
            durationValueLabel.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 4),
            durationValueLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            exercisesTitleLabel.topAnchor.constraint(equalTo: durationValueLabel.bottomAnchor, constant: 30),
            exercisesTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exercisesTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            exercisesSlider.topAnchor.constraint(equalTo: exercisesTitleLabel.bottomAnchor, constant: 8),
            exercisesSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            exercisesSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            
            exercisesValueLabel.topAnchor.constraint(equalTo: exercisesSlider.bottomAnchor, constant: 4),
            exercisesValueLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

            recomendationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            recomendationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            recomendationView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -30),
            
            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AppConstants.Layout.paddingLargeButton),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -AppConstants.Layout.paddingLargeButton),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppConstants.Layout.paddingLargeButtonBottom),
            nextButton.heightAnchor.constraint(equalToConstant: AppConstants.Layout.buttonHeightStandard),
            
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
