//
//  DescriptionExerciseLabel.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import UIKit

final class DescriptionExerciseLabel: UILabel {

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        font = .systemFont(ofSize: 14, weight: .semibold)
        textColor = UIColor(named: AppConstants.Colors.textRed)
        numberOfLines = 1
    }

}
