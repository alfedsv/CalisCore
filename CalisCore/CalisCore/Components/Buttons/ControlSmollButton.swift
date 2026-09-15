//
//  ControlSmollButton.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import UIKit

final class ControlSmollButton: UIButton {

    var currentState: CurrentState = .begin {
        didSet {
            updateUI()
        }
    }
    
    var isLocked: Bool = false {
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
        if isLocked {
            backgroundColor = UIColor(named: AppConstants.Colors.buttonUnactive)
            isUserInteractionEnabled = false
            isHidden = false
        } else {
            switch currentState {
            case .running:
                backgroundColor = .clear
                isUserInteractionEnabled = false
                isHidden = true
            case .begin:
                setTitle("controlButton.start".localized, for: .normal)
                backgroundColor = UIColor(named: AppConstants.Colors.buttonActive)
                isUserInteractionEnabled = true
                isHidden = false
            case .ended:
                setTitle("controlButton.onceMore".localized, for: .normal)
                backgroundColor = UIColor(named: AppConstants.Colors.buttonOnceMore)
                isUserInteractionEnabled = true
                isHidden = false
            case .stopped:
                setTitle("controlButton.start".localized, for: .normal)
                backgroundColor = UIColor(named: AppConstants.Colors.buttonActive)
                isUserInteractionEnabled = true
                isHidden = false
            }
        }
    }
}
