//
//  LargeButton.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import UIKit

final class LargeButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        backgroundColor = UIColor(named: AppConstants.Colors.buttonNext)
        setTitleColor(UIColor(named: AppConstants.Colors.buttonText), for: .normal)
        layer.cornerRadius = AppConstants.Layout.buttonCornerRadius
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
