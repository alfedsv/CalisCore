//
//  MainTitleLabel.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import UIKit

final class MainTitleLabel: UILabel {

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        font = .systemFont(ofSize: 24)
        textColor = UIColor(named: AppConstants.Colors.labelText)
        textAlignment = .center
        numberOfLines = 1
    }
}
