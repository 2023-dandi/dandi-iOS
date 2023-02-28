//
//  ClosetView.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/15.
//

import UIKit

import SnapKit
import Then
import YDS

final class ClosetView: UIView {
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.3),
                heightDimension: .fractionalWidth(0.3)
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
            return section
        }
        return layout
    }()

    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        collectionView.contentInset = .init(top: .zero, left: .zero, bottom: 16, right: .zero)
        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        setLayouts()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ClosetView {
    private func setLayouts() {
        addSubviews(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
