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
        
        viewModel.onNext = { [weak self] workoutModel in
            let viewController = WorkoutViewController(workoutModel: workoutModel)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    // MARK: - Setup UI

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(durationTitleLabel)
        view.addSubview(durationSlider)
        view.addSubview(durationValueLabel)
        view.addSubview(exercisesTitleLabel)
        view.addSubview(exercisesSlider)
        view.addSubview(exercisesValueLabel)
        view.addSubview(nextButton)
        view.addSubview(versionLabel)
        setupConstraints()
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
    private func nextButtonTapped() {
        viewModel.next()
    }
}

// MARK: - Layout

private extension SetupViewController {
    func setupConstraints() {
        [
            durationTitleLabel,
            durationSlider,
            durationValueLabel,
            exercisesTitleLabel,
            exercisesSlider,
            exercisesValueLabel,
            nextButton,
            versionLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            durationTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            durationTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            durationTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            durationSlider.topAnchor.constraint(equalTo: durationTitleLabel.bottomAnchor, constant: 8),
            durationSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            durationSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            durationValueLabel.topAnchor.constraint(equalTo: durationSlider.bottomAnchor, constant: 4),
            durationValueLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            exercisesTitleLabel.topAnchor.constraint(equalTo: durationValueLabel.bottomAnchor, constant: 30),
            exercisesTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exercisesTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            exercisesSlider.topAnchor.constraint(equalTo: exercisesTitleLabel.bottomAnchor, constant: 8),
            exercisesSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exercisesSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            exercisesValueLabel.topAnchor.constraint(equalTo: exercisesSlider.bottomAnchor, constant: 4),
            exercisesValueLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AppConstants.Layout.paddingLargeButton),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -AppConstants.Layout.paddingLargeButton),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppConstants.Layout.paddingLargeButtonBottom),
            nextButton.heightAnchor.constraint(equalToConstant: AppConstants.Layout.buttonHeightStandard),
            
            versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
