//
//  SetupButton.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import UIKit

final class SetupButton: UIButton {

    let command: SetupProtocol

    override var isSelected: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    init(command: SetupProtocol) {
        self.command = command
        super.init(frame: .zero)
        setupAppearance()
    }
    
    private func setupAppearance() {
        layer.cornerRadius = AppConstants.Layout.buttonCornerRadius
        setTitle(command.localizedTitle, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        setTitleColor(UIColor(named: AppConstants.Colors.buttonText), for: .normal)
        updateBackgroundColor()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateBackgroundColor() {
        if isSelected {
            backgroundColor = UIColor(named: command.activeBackgroundColor)
        } else {
            backgroundColor = UIColor(named: command.unactiveBackgroundColor)
        }
    }
}
