//
//  RecomendationView.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 21.09.2026.
//

import UIKit

final class RecomendationView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(named: AppConstants.Colors.recomendationTitle)
        label.text = "recomendation.title".localized
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: AppConstants.Colors.labelText)
        label.numberOfLines = 3
        return label
    }()
    
    init(workoutType: WorkoutType) {
        super.init(frame: .zero)
        layer.cornerRadius = AppConstants.Layout.recomendationViewCornerRadius
        addSubview(titleLabel)
        addSubview(textLabel)
        backgroundColor = UIColor(named: AppConstants.Colors.recomendationBackground)
        setupAppearance(workoutType: workoutType)
        setupConstraints()
    }
    
    func setupAppearance(workoutType: WorkoutType) {
        switch workoutType {
        case .strength:
            textLabel.text = "recomendation.strength".localized
        case .endurance:
            textLabel.text = "recomendation.endurance".localized
        case .explosivePower:
            textLabel.text = "recomendation.explosivePower".localized
        case .circuit:
            textLabel.text = "recomendation.circuit".localized
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension RecomendationView {
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14)
        ])
    }
}
