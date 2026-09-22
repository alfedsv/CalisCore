//
//  DescriptionViewController.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 22.09.2026.
//

import UIKit

/// Модальный экран с полным описанием упражнения.
/// Показывается как sheet, поддерживает скролл для длинного текста.
final class DescriptionViewController: UIViewController {

    // MARK: - Dependencies

    private let text: String

    // MARK: - UI Elements

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = TitleLabel()
    private let descriptionLabel = DescriptionLabel()

    // MARK: - Init

    init(title: String, description: String) {
        self.text = description
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        titleLabel.textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    // MARK: - Setup UI

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        descriptionLabel.text = text

    }
}

// MARK: - Layout

private extension DescriptionViewController {
    func setupConstraints() {
        [
            scrollView,
            contentView,
            titleLabel,
            descriptionLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
}
