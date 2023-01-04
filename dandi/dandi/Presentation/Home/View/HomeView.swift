//
//  HomeView.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import UIKit

import SnapKit

final class HomeView: UIView {
    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] index, _ in
            switch index {
            case 0:
                return self?.createWeatherBannerSectionLayout()
            case 1:
                return self?.createWeatherDetailSectionLayout()
            default:
                return self?.createCardSectionLayout()
            }
        }
        return layout
    }()

    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
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

extension HomeView {
    private func setLayouts() {
        addSubviews(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }

    private func createWeatherBannerSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(240 / 375)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }

    private func createWeatherDetailSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(56),
            heightDimension: .absolute(96)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(20)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 12, leading: 20, bottom: 12, trailing: 20)

        return section
    }

    private func createCardSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(318 / 375)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(10)
        group.contentInsets = .init(top: .zero, leading: 12, bottom: .zero, trailing: 12)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(62)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.pinToVisibleBounds = true

        section.boundarySupplementaryItems = [header]

        return section
    }
}
