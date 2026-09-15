//
//  TitleLabel.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import UIKit

final class TitleLabel: UILabel {

    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        font = .systemFont(ofSize: 16, weight: .semibold)
        textColor = UIColor(named: AppConstants.Colors.labelText)
        numberOfLines = 0
    }
}
