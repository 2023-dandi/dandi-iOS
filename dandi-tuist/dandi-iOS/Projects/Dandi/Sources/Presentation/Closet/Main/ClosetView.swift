//
//  ClosetView.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/03.
//

import UIKit

import SnapKit
import YDS

final class ClosetView: UIView {
    private(set) lazy var categoryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: self.bounds,
            collectionViewLayout: createMainCategoryTabCollectionLayout()
        )
        collectionView.register(cell: PagerCollectionViewCell.self)
        collectionView.bounces = false
        setCollectionView(collectionView)
        return collectionView
    }()

    private(set) lazy var tagCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: self.bounds,
            collectionViewLayout: createTagCollectionViewLayout()
        )
        collectionView.register(cell: RoundTagCollectionViewCell.self)
        collectionView.bounces = false
        collectionView.allowsMultipleSelection = true
        setCollectionView(collectionView)
        return collectionView
    }()

    private(set) lazy var photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: self.bounds,
            collectionViewLayout: createPhotoCollectionViewLayout()
        )
        collectionView.register(cell: ImageCollectionViewCell.self)
        collectionView.allowsMultipleSelection = true
        collectionView.contentInset = .init(top: .zero, left: .zero, bottom: 20, right: .zero)
        setCollectionView(collectionView)
        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        render()
    }

    private func render() {
        addSubviews(categoryCollectionView, tagCollectionView, photoCollectionView)
        categoryCollectionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(48)
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

    private func setCollectionView(_ collectionView: UICollectionView) {
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Create CollectionView Layout

extension ClosetView {
    private func createMainCategoryTabCollectionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(80),
            heightDimension: .absolute(48)
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
