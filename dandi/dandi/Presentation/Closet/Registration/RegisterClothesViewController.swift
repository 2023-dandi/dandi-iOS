//
//  RegisterClothesViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

import RxCocoa
import RxSwift
import YDS

final class RegisterClothesViewController: BaseViewController {
    private let registrationView = RegisterClothesView()

    private let navigationBar = YDSTopBar()
    private let backButton = UIButton()
    private let saveButton = YDSBoxButton()

    private let categories: [ClothesCategory] = ClothesCategory.allCases
    private let seasons: [Season] = Season.allCases

    private let images: [UIImage]
    private var selectedCategoryIndex: Int = 0

    init(selectedImages: [UIImage]) {
        self.images = selectedImages
        super.init()
        setCollectionView()
        setProperties()
        setLayouts()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    func bind() {
        backButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        saveButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.navigationController?.dismiss(animated: true)
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
        saveButton.setBackgroundColor(YDSColor.buttonPoint, for: .normal)
        saveButton.setBackgroundColor(YDSColor.buttonDisabledBG, for: .disabled)
        saveButton.text = "업로드"
        saveButton.rounding = .r8
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
        didSelectItemAt indexPath: IndexPath
    ) {
        switch indexPath.section {
        case 1:
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            cell.isSelected = true
        case 2:
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            cell.isSelected = true
        default:
            return
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
            return images.count
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
            cell.configure(image: images[indexPath.item])
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
