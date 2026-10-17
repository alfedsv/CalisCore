//
//  CharacterCarouselCell.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 17.10.2026.
//


import UIKit

/// Ячейка карусели — только визуальная рамка и имя.
/// 3D-контент рендерится в общем ARView, который лежит под collectionView.
final class CharacterCarouselCell: UICollectionViewCell {

    static let reuseIdentifier = "CharacterCarouselCell"

    // MARK: - UI

    private let nameLabel = UILabel()
    private let cardView = UIView()

    // MARK: - State

    private var isCardFocused: Bool = false

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.35)
        cardView.layer.cornerRadius = 24
        cardView.layer.borderWidth = 2
        cardView.layer.borderColor = UIColor.clear.cgColor
        cardView.clipsToBounds = true

        cardView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        nameLabel.textColor = UIColor(named: AppConstants.Colors.labelText)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])

        cardView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        cardView.alpha = 0.75
    }

    // MARK: - Configuration

    func configure(with character: Character) {
        nameLabel.text = character.name
    }

    // MARK: - Focus

    func setFocused(_ focused: Bool) {
        guard isCardFocused != focused else { return }
        isCardFocused = focused

        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: [.curveEaseInOut, .allowUserInteraction]) {
            self.cardView.transform = focused
                ? .identity
                : CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.cardView.alpha = focused ? 1.0 : 0.75
            self.cardView.layer.borderColor = focused
                ? UIColor.systemBlue.cgColor
                : UIColor.clear.cgColor
        }
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        isCardFocused = false
        cardView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        cardView.alpha = 0.75
        cardView.layer.borderColor = UIColor.clear.cgColor
        nameLabel.text = nil
    }
}
