//
//  RegisterClothesViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import YDS

final class RegisterClothesViewController: BaseViewController, View {
    typealias Reactor = RegisterClothesReactor

    private let registrationView = RegisterClothesView()

    private let navigationBar = YDSTopBar()
    private let backButton = UIButton()
    private let saveButton = YDSBoxButton()

    private let categories: [ClothesCategory] = ClothesCategory.allCases
    private let seasons: [Season] = Season.allCases

    private let image: UIImage

    private var selectedIndexPaths = Set<IndexPath>() {
        didSet {
            let selectedCategory: Int? = selectedIndexPaths.filter { $0.section == 1 }.first?.item
            let selectedSeasons = selectedIndexPaths.filter { $0.section == 2 }.map { $0.item }
            saveButton.isDisabled = selectedCategory == nil || selectedSeasons.isEmpty
        }
    }

    init(selectedImage: UIImage) {
        self.image = selectedImage
        super.init()
        setCollectionView()
        setProperties()
        setLayouts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    func bind(reactor: Reactor) {
        bindTapActions()
        bindState(reactor)
        bindAction(reactor)
    }

    private func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.successUpload }
            .distinctUntilChanged()
            .compactMap { $0 }
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                NotificationCenterManager.reloadCloset.post()
                self?.navigationController?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func bindAction(_ reactor: Reactor) {
        saveButton.rx.tap
            .map { [weak self] _ -> ClothesInfo? in
                guard
                    let self = self,
                    let selectedCategory: Int = self.selectedIndexPaths.filter({ $0.section == 1 }).first?.item,
                    let clothesCategory: ClothesCategory = ClothesCategory(rawValue: selectedCategory + 1)
                else { return nil }
                let selectedSeasons = self.selectedIndexPaths.filter { $0.section == 2 }.map { $0.item }
                let seasons: [Season] = selectedSeasons.compactMap { Season(rawValue: $0 + 1) }.compactMap { $0 }
                self.saveButton.isDisabled = true
                return ClothesInfo(category: clothesCategory, seasons: seasons, image: self.image)
            }
            .compactMap { $0 }
            .map { Reactor.Action.upload(category: $0.category, seasons: $0.seasons, clothesImage: $0.image) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindTapActions() {
        backButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setProperties() {
        navigationBar.topItem?.title = "옷 등록"
        backButton.setImage(YDSIcon.arrowLeftLine, for: .normal)
        navigationBar
            .topItem?
            .setLeftBarButton(
                UIBarButtonItem(customView: backButton),
                animated: false
            )
        saveButton.text = "업로드"
        saveButton.rounding = .r8
        saveButton.isDisabled = true
    }

    private func setLayouts() {
        view.addSubviews(navigationBar, registrationView, saveButton)
        navigationBar.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        registrationView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(navigationBar.snp.bottom)
        }
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }

    private func setCollectionView() {
        registrationView.collectionView.dataSource = self
        registrationView.collectionView.delegate = self

        registrationView.collectionView.register(cell: ImageCollectionViewCell.self)
        registrationView.collectionView.register(cell: RoundTagCollectionViewCell.self)
        registrationView.collectionView.register(cell: PagerCollectionViewCell.self)
        registrationView.collectionView.register(
            SectionTitleHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionTitleHeaderView.reuseIdentifier
        )
        registrationView.collectionView.allowsMultipleSelection = true
    }
}

extension RegisterClothesViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        if indexPath.section == 1 {
            if selectedIndexPaths.contains(indexPath) {
                selectedIndexPaths.remove(indexPath)
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            }
            selectedIndexPaths.forEach { selectedIndexPath in
                if selectedIndexPath.section == 1 {
                    selectedIndexPaths.remove(selectedIndexPath)
                    collectionView.deselectItem(at: selectedIndexPath, animated: true)
                }
            }
            selectedIndexPaths.insert(indexPath)
        } else {
            selectedIndexPaths.insert(indexPath)
        }
        return true
    }

    func collectionView(
        _: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if indexPath.section == 2 {
            selectedIndexPaths.insert(indexPath)
        }
    }

    func collectionView(
        _: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        if indexPath.section == 2 {
            selectedIndexPaths.remove(indexPath)
        }
    }
}

extension RegisterClothesViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 3
    }

    func collectionView(
        _: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return categories.count
        case 2:
            return seasons.count
        default:
            break
        }
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.type = .none
            cell.configure(image: image)
            return cell

        case 1:
            let cell: PagerCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(text: categories[indexPath.item].text)
            return cell

        case 2:
            let cell: RoundTagCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(text: seasons[indexPath.item].text)
            return cell

        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(
        _: UICollectionView,
        viewForSupplementaryElementOfKind _: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch indexPath.section {
        case 1:
            let header: SectionTitleHeaderView = registrationView
                .collectionView
                .dequeueHeaderView(forIndexPath: indexPath)
            header.configure(text: "이 옷의 종류를 알려주세요!")
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
