//
//  DescriptionButton.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import UIKit

final class DescriptionButton: UIButton {

    init() {
        super.init(frame: .zero)
        titleLabel?.font = .systemFont(ofSize: 14)
        setTitleColor(UIColor(named: AppConstants.Colors.buttonText), for: .normal)
        backgroundColor = UIColor(named: AppConstants.Colors.buttonActive)
        layer.cornerRadius = AppConstants.Layout.buttonCornerRadius
        setTitle("descriptionButton.text".localized, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
