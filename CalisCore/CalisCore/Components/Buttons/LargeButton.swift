//
//  LargeButton.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import UIKit

final class LargeButton: UIButton {

    var isActive: Bool {
        didSet {
            updateUI()
        }
    }
    
    init(title: String, isActive: Bool) {
        self.isActive = isActive
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        setTitleColor(UIColor(named: AppConstants.Colors.buttonText), for: .normal)
        layer.cornerRadius = AppConstants.Layout.buttonCornerRadius
        updateUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
        if isActive {
            backgroundColor = UIColor(named: AppConstants.Colors.buttonNext)
            isUserInteractionEnabled = true
        } else {
            backgroundColor = UIColor(named: AppConstants.Colors.buttonUnactive)
            isUserInteractionEnabled = false
        }
    }
            
}
