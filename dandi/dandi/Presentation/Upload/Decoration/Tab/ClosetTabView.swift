//
//  ClosetTabView.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

import YDS

final class ClosetTabView: UIView {
    private(set) lazy var categoryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: self.bounds,
            collectionViewLayout: createMainCategoryTabCollectionLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: CategoryTextCollectionViewCell.self)
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()

    private(set) lazy var tagCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: self.bounds,
            collectionViewLayout: createTagCollectionViewLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: RoundTagCollectionViewCell.self)
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()

    private(set) lazy var photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: self.bounds,
            collectionViewLayout: createPhotoCollectionViewLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: .zero, left: .zero, bottom: 16, right: .zero)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: ImageCollectionViewCell.self)
        return collectionView
    }()

    private var category: [String] = []
    private var tagList: [String] = []
    private var photo: [UIImage] = []

    init() {
        super.init(frame: .zero)
        render()
    }

    func update(
        category: [String],
        tagList: [String],
        photo: [UIImage]
    ) {
        self.category = category
        self.tagList = tagList
        self.photo = photo

        categoryCollectionView.reloadData()
        tagCollectionView.reloadData()
        photoCollectionView.reloadData()
    }

    private func render() {
        addSubviews(categoryCollectionView, tagCollectionView, photoCollectionView)
        categoryCollectionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(36)
        }
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagCollectionView.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ClosetTabView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection _: Int
    ) -> Int {
        switch collectionView {
        case categoryCollectionView:
            return category.count
        case tagCollectionView:
            return tagList.count
        case photoCollectionView:
            return photo.count
        default:
            break
        }

        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch collectionView {
        case categoryCollectionView:
            let cell: CategoryTextCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(text: category[indexPath.item])
            return cell

        case tagCollectionView:
            let cell: RoundTagCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(text: tagList[indexPath.item])

            return cell

        case photoCollectionView:
            let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(image: photo[indexPath.item])
            return cell

        default:
            return UICollectionViewCell()
        }
    }
}

extension ClosetTabView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch collectionView {
        case categoryCollectionView:
            print("mainCategoryTabCollectionView")
            print(indexPath)
        case tagCollectionView:
            print("tagTabCollectionView")
            print(indexPath)
        case photoCollectionView:
            print("photoCollectionView")
            print(indexPath)
        default:
            break
        }
    }
}

// MARK: - Create CollectionView Layout

extension ClosetTabView {
    private func createMainCategoryTabCollectionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .absolute(36)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: .zero, leading: 16, bottom: .zero, trailing: 16)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func createTagCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .absolute(26)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(16)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func createPhotoCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 3),
            heightDimension: .fractionalWidth(1 / 3)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: itemSize.heightDimension
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )
        group.interItemSpacing = .fixed(2)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2
        section.contentInsets = .init(top: .zero, leading: .zero, bottom: 16, trailing: .zero)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
