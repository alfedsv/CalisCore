//
//  SetupButton.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 21.09.2026.
//

import UIKit

final class SetupButton: UIButton {

    let workoutType: WorkoutType
    
    override var isSelected: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    init(workoutType: WorkoutType) {
        self.workoutType = workoutType
        super.init(frame: .zero)
        setupAppearance(workoutType: workoutType)
    }
    
    private func setupAppearance(workoutType: WorkoutType) {
        layer.cornerRadius = AppConstants.Layout.buttonCornerRadius
        setTitle(workoutType.localizedTitle, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        setTitleColor(UIColor(named: AppConstants.Colors.buttonText), for: .normal)
        updateBackgroundColor()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateBackgroundColor() {
        backgroundColor = isSelected ? UIColor(named: AppConstants.Colors.setupActive) : UIColor(named: AppConstants.Colors.setupUnactive)
    }
}
