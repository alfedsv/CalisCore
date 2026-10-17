//
//  CharacterCarouselViewController.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 17.10.2026.
//


import UIKit

/// Экран выбора персонажа с одним общим ARView.
/// - `collectionView` прозрачен и служит только для позиционирования.
/// - 3D-контент рендерится в `animationView`, который лежит под collectionView.
/// - При смене фокуса `animationView` переключается на модель нового персонажа.
final class CharacterCarouselViewController: UIViewController {

    // MARK: - Dependencies

    private let viewModel: CharacterCarouselViewModelProtocol

    // MARK: - UI

    private let titleLabel = MainTitleLabel(text: "carousel.title".localized)
    private let animationView = RealityExerciseAnimationView()
    private let collectionView: UICollectionView
    private let nextButton = LargeButton(title: "largeButton.next".localized, isActive: true)

    // MARK: - State

    private var currentCenteredIndex: Int = -1
    private var hasAppliedInitialFocus = false

    // MARK: - Init

    init() {
        self.viewModel = CharacterCarouselViewModel()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.resumeRendering()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Ключевой момент: layout уже посчитан, collectionView имеет bounds.
        // Форсируем layout на всякий случай и запускаем первый фокус.
        view.layoutIfNeeded()

        if !hasAppliedInitialFocus {
            // Первый показ — принудительно применяем фокус и запускаем анимацию.
            hasAppliedInitialFocus = true
            updateFocusedCell(force: true)
        } else {
            // Возврат на экран — пересчитываем и перезапускаем анимацию.
            updateFocusedCell(force: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationView.pauseRendering()
    }

    // MARK: - Setup UI

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CharacterCarouselCell.self,
                                forCellWithReuseIdentifier: CharacterCarouselCell.reuseIdentifier)
        view.addSubview(collectionView)

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            animationView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),

            collectionView.topAnchor.constraint(equalTo: animationView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: animationView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: animationView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: animationView.bottomAnchor),

            nextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AppConstants.Layout.paddingLargeButton),
            nextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -AppConstants.Layout.paddingLargeButton),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppConstants.Layout.paddingLargeButtonBottom),
            nextButton.heightAnchor.constraint(equalToConstant: AppConstants.Layout.buttonHeightStandard)
        ])
    }

    // MARK: - Binding

    private func bindViewModel() {
        viewModel.onNext = { [weak self] character in
            print("🎭 Selected character: \(character.id) (\(character.name))")

            let vc = SetupViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - Actions

    @objc
    private func nextTapped() {
        viewModel.next()
    }

    // MARK: - Focus

    private func updateFocusedCell(force: Bool = false) {
        guard collectionView.bounds.width > 0 else {
            // Layout ещё не готов — отложим на следующий цикл.
            DispatchQueue.main.async { [weak self] in
                self?.updateFocusedCell(force: force)
            }
            return
        }
        guard let index = closestItemIndex() else { return }
        if !force && index == currentCenteredIndex { return }

        currentCenteredIndex = index
        viewModel.selectCharacter(at: index)

        for cell in collectionView.visibleCells {
            guard let charCell = cell as? CharacterCarouselCell,
                  let ip = collectionView.indexPath(for: charCell) else { continue }
            charCell.setFocused(ip.item == index)
        }

        let character = viewModel.characters[index]

        #if DEBUG
        print("🎠 updateFocusedCell → index=\(index), character=\(character.name), scene=\(character.danceScene.name)")
        #endif

        animationView.play(scene: character.danceScene, loop: true)
    }

    private func closestItemIndex() -> Int? {
        let center = CGPoint(
            x: collectionView.contentOffset.x + collectionView.bounds.width / 2,
            y: collectionView.bounds.height / 2
        )

        var closest: (index: Int, distance: CGFloat)?
        for indexPath in collectionView.indexPathsForVisibleItems {
            guard let attrs = collectionView.layoutAttributesForItem(at: indexPath) else { continue }
            let itemCenter = attrs.center
            let distance = hypot(itemCenter.x - center.x, itemCenter.y - center.y)
            if closest == nil || distance < closest!.distance {
                closest = (indexPath.item, distance)
            }
        }
        return closest?.index
    }

    private func snapToNearest() {
        guard collectionView.bounds.width > 0 else { return }
        guard let index = closestItemIndex() else { return }
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - DataSource / Delegate

extension CharacterCarouselViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel.characters.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacterCarouselCell.reuseIdentifier,
            for: indexPath
        ) as! CharacterCarouselCell

        let character = viewModel.characters[indexPath.item]
        cell.configure(with: character)

        if indexPath.item == viewModel.selectedIndex {
            cell.setFocused(true)
        }
        return cell
    }
}

extension CharacterCarouselViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width = min(height * 0.85, collectionView.bounds.width * 0.7)
        return CGSize(width: width, height: height)
    }
}

// MARK: - UIScrollViewDelegate

extension CharacterCarouselViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateFocusedCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        if !decelerate {
            snapToNearest()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapToNearest()
    }
}
