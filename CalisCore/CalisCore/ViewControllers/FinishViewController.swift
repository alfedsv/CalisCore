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
    private let animationView = ExerciseAnimationView()
    
    private let winLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = UIColor(named: AppConstants.Colors.textRed)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let toMainButton = LargeButton(title: "largeButton.toMain".localized, isActive: true)
    
    init() {
        self.viewModel = FinishViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
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
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(animationView)
        animationView.preload(scenes: [
            DataSource.victory
        ]) { [weak self] in
            self?.playLoop()
        }
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

    private func playLoop() {
        let scene = DataSource.victory
        animationView.play(scene: scene, loop: true)
    }

}

// MARK: - Layout

extension FinishViewController {
    private func setupConstraints() {
        [
            titleLabel,
            animationView,
            winLabel,
            toMainButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            animationView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.Layout.animationViewPadding),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppConstants.Layout.animationViewPadding),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor),
            
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
