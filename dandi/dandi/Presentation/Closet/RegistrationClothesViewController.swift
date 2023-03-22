//
//  RegistrationClothesViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

struct ClothesCategory {
    let title: String
    let sub: [String]
}

final class RegistrationClothesViewController: BaseViewController {
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
    private var selectedSubCategoryItems = [Int: [Int]]() {
        didSet {
            for key in selectedSubCategoryItems.keys {
                dump(selectedSubCategoryItems[key])
            }
        }
    }

    override func loadView() {
        view = registrationView
    }

    init(selectedImages: [UIImage]) {
        self.selectedImages = selectedImages
        super.init()
        setCollectionView()
        bindCollectionView()
    }

    private func setCollectionView() {
        registrationView.collectionView.dataSource = self
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

    private func bindCollectionView() {
        registrationView.collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                switch indexPath.section {
                case 1:
                    guard let cell = self.registrationView.collectionView.cellForItem(at: indexPath) else { return }
                    self.selectedCategoryIndex = indexPath.item
                    self.deselectAllItems(exclude: indexPath)
                    self.registrationView.collectionView.reloadSections(IndexSet(integer: 2))
                    cell.isSelected = true
                case 2:
                    guard let cell = self.registrationView.collectionView.cellForItem(at: indexPath) else { return }
                    cell.isSelected = true
                    guard var selectedSubcategory = self.selectedSubCategoryItems[self.selectedCategoryIndex] else {
                        self.selectedSubCategoryItems[self.selectedCategoryIndex] = [indexPath.item]
                        return
                    }
                    if !selectedSubcategory.contains(indexPath.item) {
                        self.selectedSubCategoryItems[self.selectedCategoryIndex]?.append(indexPath.item)
                    }
                default:
                    return
                }
            })
            .disposed(by: disposeBag)

        registrationView.collectionView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                switch indexPath.section {
                case 2:
                    guard let cell = self.registrationView.collectionView.cellForItem(at: indexPath) else { return }
                    cell.isSelected = false

                    guard var selectedSubcategory = self.selectedSubCategoryItems[self.selectedCategoryIndex] else {
                        return
                    }
                    if selectedSubcategory.contains(indexPath.item) {
                        self.selectedSubCategoryItems[self.selectedCategoryIndex] = selectedSubcategory.filter { $0 != indexPath.item }
                    }
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
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
