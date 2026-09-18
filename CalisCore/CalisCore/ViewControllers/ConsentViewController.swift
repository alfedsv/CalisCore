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
        label.textColor = UIColor(named: "labelText")
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "consent.subtitle".localized
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(named: "labelText")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let termsTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isScrollEnabled = true
        tv.font = .systemFont(ofSize: 14)
        tv.backgroundColor = .lightGray
        tv.layer.cornerRadius = 12
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        return tv
    }()
    
    private let checkboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tintColor = UIColor(named: "consent")
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
        view.backgroundColor = .white
        setupUI()
        setupActions()
        termsTextView.attributedText = TermsContent.combinedAttributedText()
        termsTextView.contentOffset = .zero
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        // Чекбокс + текст в горизонтальном стеке
        let consentRow = UIStackView(arrangedSubviews: [checkboxButton, agreementLabel])
        consentRow.axis = .horizontal
        consentRow.spacing = 8
        consentRow.alignment = .top
        
        [
            titleLabel,
            subtitleLabel,
            termsTextView,
            consentRow,
            continueButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setupConstraints(consentRow: consentRow)
    }
    
    private func setupActions() {
        checkboxButton.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        
        // Тап по тексту тоже переключает галочку — удобно для пользователя
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

extension ConsentViewController {
    private func setupConstraints(consentRow: UIStackView) {
        let safe = view.safeAreaLayoutGuide
        let hInset: CGFloat = 20
        
        NSLayoutConstraint.activate([
            // Заголовок — сверху
            titleLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hInset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hInset),
            
            // Подзаголовок — под заголовком
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hInset),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hInset),
            
            // Текстовое поле — тянется по вертикали, заполняя всё свободное место
            termsTextView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            termsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hInset),
            termsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hInset),
            
            // Чекбокс — под текстовым полем
            consentRow.topAnchor.constraint(equalTo: termsTextView.bottomAnchor, constant: 16),
            consentRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hInset),
            consentRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hInset),
            
            // Кнопка — под чекбоксом, прижата к низу
            continueButton.topAnchor.constraint(equalTo: consentRow.bottomAnchor, constant: 16),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hInset),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hInset),
            continueButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalToConstant: 52),
            
            // Чекбокс — фиксированный размер
            checkboxButton.widthAnchor.constraint(equalToConstant: 32),
            checkboxButton.heightAnchor.constraint(equalToConstant: 32),
            
            // Минимальная высота текстового поля — чтобы на маленьких экранах
            // заголовок и кнопка не выдавливали его полностью
            termsTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 160)
        ])
    }
}
