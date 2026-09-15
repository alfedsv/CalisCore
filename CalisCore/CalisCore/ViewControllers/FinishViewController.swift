//
//  FinishViewController.swift
//  ExtractSport
//
//  Created by  Alexander Fedoseev on 25.08.2026.
//

import UIKit

final class FinishViewController: UIViewController {

    private let viewModel: FinishViewModelProtocol
    
    private let titleLabel = MainTitleLabel(text: "finish.title".localized)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(named: "win")
        return imageView
    }()
    
    private let winLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = UIColor(named: AppConstants.Colors.textRed)
        label.textAlignment = .center
        return label
    }()

    private let toMainButton = LargeButton(title: "largeButton.toMain".localized)
    
    init() {
        self.viewModel = FinishViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.onToMain = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(winLabel)
        view.addSubview(toMainButton)
        winLabel.text = viewModel.win
        toMainButton.addTarget(self, action: #selector(toMainButtonTapped), for: .touchUpInside)
        setupConstraints()
    }
        
    @objc
    private func toMainButtonTapped() {
        viewModel.toMain()
    }

}
extension FinishViewController {
    private func setupConstraints() {
        [
            titleLabel,
            imageView,
            winLabel,
            toMainButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            winLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 35),
            winLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -35),
            winLabel.bottomAnchor.constraint(equalTo: toMainButton.bottomAnchor, constant: -100),
            
            toMainButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AppConstants.Layout.paddingLargeButton),
            toMainButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -AppConstants.Layout.paddingLargeButton),
            toMainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppConstants.Layout.paddingLargeButtonBottom),
            toMainButton.heightAnchor.constraint(equalToConstant: AppConstants.Layout.buttonHeightStandard)
        ])
    }
}
