//
//  ControlLargeButton.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import UIKit

final class ControlLargeButton: UIButton {

    var currentState: CurrentState = .begin {
        didSet {
            updateUI()
        }
    }

    init() {
        super.init(frame: .zero)
        titleLabel?.font = .systemFont(ofSize: 14)
        setTitleColor(UIColor(named: AppConstants.Colors.buttonText), for: .normal)
        layer.cornerRadius = AppConstants.Layout.buttonCornerRadius
        updateUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateUI() {
        switch currentState {
        case .running:
            setTitle("controlButton.stop".localized, for: .normal)
            backgroundColor = UIColor(named: AppConstants.Colors.buttonUnactive)
            isUserInteractionEnabled = true
        case .begin:
            setTitle("controlButton.start".localized, for: .normal)
            backgroundColor = UIColor(named: AppConstants.Colors.buttonActive)
            isUserInteractionEnabled = true
        case .ended:
            setTitle("controlButton.finished".localized, for: .normal)
            backgroundColor = UIColor(named: AppConstants.Colors.buttonUnactive)
            isUserInteractionEnabled = false
        case .stopped:
            setTitle("controlButton.start".localized, for: .normal)
            backgroundColor = UIColor(named: AppConstants.Colors.buttonActive)
            isUserInteractionEnabled = true
        }
    }
}
