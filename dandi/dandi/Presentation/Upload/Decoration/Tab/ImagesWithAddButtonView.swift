//
//  ImagesWithAddButtonView.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/26.
//

import UIKit

final class ImagesWithAddButtonView: UIView {
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.contentInset = .init(top: 16, left: .zero, bottom: 16, right: .zero)
        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        render()
    }

    private func render() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImagesWithAddButtonView {
    private func createLayout() -> UICollectionViewLayout {
        let margin: CGFloat = 26
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 4),
            heightDimension: .fractionalWidth(1 / 4)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupHeight: CGFloat = (UIScreen.main.bounds.width - margin * 2) / 4
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(groupHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 4
        )
        group.interItemSpacing = .fixed(12)
        group.contentInsets = .init(top: .zero, leading: margin, bottom: .zero, trailing: margin)

        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
