//
//  ConsentViewController.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 18.09.2026.
//

import UIKit

final class ConsentViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "consent.title".localized
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 0
        label.textColor = UIColor(named: AppConstants.Colors.labelText)
        label.textAlignment = .center
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "consent.subtitle".localized
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(named: AppConstants.Colors.labelText)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private let termsTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.font = .systemFont(ofSize: 14)
        textView.backgroundColor = .lightGray
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        return textView
    }()
    private let checkboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tintColor = UIColor(named: AppConstants.Colors.checkboxButton)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.text = "consent.checkbox".localized
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    private let continueButton = LargeButton(title: "largeButton.consent".localized, isActive: false)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        termsTextView.attributedText = TermsContent.combinedAttributedText()
        termsTextView.contentOffset = .zero
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        // Чекбокс + текст в горизонтальном стеке
        let consentRow = UIStackView(arrangedSubviews: [checkboxButton, agreementLabel])
        consentRow.axis = .horizontal
        consentRow.spacing = 8
        consentRow.alignment = .top
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(termsTextView)
        view.addSubview(consentRow)
        view.addSubview(continueButton)
        setupConstraints(consentRow: consentRow)
    }
    
    private func setupActions() {
        checkboxButton.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        // Тап по тексту тоже переключает галочку
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleCheckbox))
        agreementLabel.isUserInteractionEnabled = true
        agreementLabel.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    
    @objc
    private func toggleCheckbox() {
        checkboxButton.isSelected.toggle()
        continueButton.isActive = checkboxButton.isSelected
        UIView.animate(withDuration: 0.1) {
            self.checkboxButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.checkboxButton.transform = .identity
            }
        }
    }
    
    @objc
    private func continueTapped() {
        // Сохраняем согласие
        ConsentManager.shared.saveConsent()
        
        // Переключаем rootViewController через SceneDelegate
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.switchToMain()
        }
    }
}

// MARK: - Layout

private extension ConsentViewController {
    func setupConstraints(consentRow: UIStackView) {
        [
            titleLabel,
            subtitleLabel,
            termsTextView,
            consentRow,
            continueButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let hInset: CGFloat = 20
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: hInset),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -hInset),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: hInset),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -hInset),
            
            termsTextView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            termsTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: hInset),
            termsTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -hInset),
            
            consentRow.topAnchor.constraint(equalTo: termsTextView.bottomAnchor, constant: 16),
            consentRow.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: hInset),
            consentRow.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -hInset),

            continueButton.topAnchor.constraint(equalTo: consentRow.bottomAnchor, constant: 16),
            continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AppConstants.Layout.paddingLargeButton),
            continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -AppConstants.Layout.paddingLargeButton),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppConstants.Layout.paddingLargeButtonBottom),
            continueButton.heightAnchor.constraint(equalToConstant: AppConstants.Layout.buttonHeightStandard),

            checkboxButton.widthAnchor.constraint(equalToConstant: AppConstants.Layout.checkboxButtonSide),
            checkboxButton.heightAnchor.constraint(equalToConstant: AppConstants.Layout.checkboxButtonSide),
            
            // Минимальная высота текстового поля — чтобы на маленьких экранах
            // заголовок и кнопка не выдавливали его полностью
            termsTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 160)
        ])
    }
}
