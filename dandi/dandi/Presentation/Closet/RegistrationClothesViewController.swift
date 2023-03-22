//
//  RegistrationClothesViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

import RxCocoa
import RxSwift
import YDS

struct ClothesCategory {
    let title: String
    let sub: [String]
}

final class RegistrationClothesViewController: BaseViewController {
    typealias CategoryItems = [Int: [Int]]

    private let navigationBar = YDSTopBar()
    private let backButton = UIButton()
    private let saveButton = YDSBoxButton()
    private let registrationView = RegistrationClothesView()

    private let category: [ClothesCategory] = [
        ClothesCategory(title: "상의", sub: ["티셔츠", "반팔", "맨투맨", "긴팔", "기타"]),
        ClothesCategory(title: "하의", sub: ["티셔츠", "반팔", "맨투맨", "긴팔", "기타"]),
        ClothesCategory(title: "아우터", sub: ["티셔츠", "반팔", "맨투맨", "긴팔", "기타"]),
        ClothesCategory(title: "악세사리", sub: ["티셔츠", "반팔", "맨투맨", "긴팔", "기타"]),
        ClothesCategory(title: "기타", sub: ["티셔츠", "반팔", "맨투맨", "긴팔", "기타"])
    ]

    private let selectedImages: [UIImage]
    private var selectedCategoryIndex: Int = 0
    private var visibleImageIndex: Int = 0
    private var selectedSubCategoryItems = CategoryItems() {
        didSet {
            for key in selectedSubCategoryItems.keys {
                dump(selectedSubCategoryItems[key])
            }
        }
    }

    init(selectedImages: [UIImage]) {
        self.selectedImages = selectedImages
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

    private func deselectAllItems(exclude: IndexPath, animated: Bool = false) {
        for indexPath in registrationView.collectionView.indexPathsForSelectedItems ?? [] {
            if indexPath == exclude { continue }
            if indexPath.section == 1 {
                registrationView.collectionView.deselectItem(at: indexPath, animated: animated)
                registrationView.collectionView.cellForItem(at: indexPath)?.isSelected = false
            }
        }
    }
}

extension RegistrationClothesViewController: UICollectionViewDelegate {
    func collectionView(
        _: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch indexPath.section {
        case 1:
            guard let cell = registrationView.collectionView.cellForItem(at: indexPath) else { return }
            selectedCategoryIndex = indexPath.item
            deselectAllItems(exclude: indexPath)
            registrationView.collectionView.reloadSections(IndexSet(integer: 2))
            cell.isSelected = true
        case 2:
            guard let cell = registrationView.collectionView.cellForItem(at: indexPath) else { return }
            cell.isSelected = true
            guard let selectedSubcategory = selectedSubCategoryItems[selectedCategoryIndex] else {
                selectedSubCategoryItems[selectedCategoryIndex] = [indexPath.item]
                return
            }
            if !selectedSubcategory.contains(indexPath.item) {
                selectedSubCategoryItems[selectedCategoryIndex]?.append(indexPath.item)
            }
        default:
            return
        }
    }

    func collectionView(
        _: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        switch indexPath.section {
        case 2:
            guard let cell = registrationView.collectionView.cellForItem(at: indexPath) else { return }
            cell.isSelected = false

            guard let selectedSubcategory = selectedSubCategoryItems[selectedCategoryIndex] else {
                return
            }
            if selectedSubcategory.contains(indexPath.item) {
                selectedSubCategoryItems[selectedCategoryIndex] = selectedSubcategory.filter { $0 != indexPath.item }
            }
        default:
            return
        }
    }
}

extension RegistrationClothesViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 3
    }

    func collectionView(
        _: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0:
            return selectedImages.count
        case 1:
            return category.count
        case 2:
            return category[selectedCategoryIndex].sub.count
        default:
            break
        }
        return 0
    }

    func collectionView(
        _: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell: ImageCollectionViewCell = registrationView.collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.type = .none
            cell.configure(image: selectedImages[indexPath.item])
            return cell

        case 1:
            let cell: PagerCollectionViewCell = registrationView.collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(text: category[indexPath.item].title)
            if indexPath.item == selectedCategoryIndex {
                cell.isSelected = true
                registrationView.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
            }
            return cell

        case 2:
            let cell: RoundTagCollectionViewCell = registrationView.collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(text: category[selectedCategoryIndex].sub[indexPath.item])

            if let category = selectedSubCategoryItems[selectedCategoryIndex] {
                if category.contains(indexPath.item) {
                    cell.isSelected = true
                    registrationView.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
                }
            }
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
