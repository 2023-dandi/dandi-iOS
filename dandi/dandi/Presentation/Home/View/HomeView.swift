//
//  HomeView.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import UIKit

import SnapKit
import Then
import YDS

final class HomeView: UIView {
    private(set) lazy var notificationButton = YDSTopBarButton(image: YDSIcon.bellLine)
    private(set) lazy var bannerView = WeatherBannerView()

    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: .zero, left: .zero, bottom: 60, right: .zero)
        collectionView.delegate = self
        return collectionView
    }()

    private(set) lazy var statusBarView = UIView()

    private var colors: [UIColor] = []

    init() {
        super.init(frame: .zero)
        setProperties()
        setLayouts()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bannerView.addGradient(colors: colors)
    }

    public func configure(
        temperature: String,
        description: String
    ) {
        bannerView.do {
            $0.configure(
                temperature: temperature,
                description: description
            )
        }
    }

    public func setGradientColors(colors: [UIColor]) {
        self.colors = colors
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView {
    private func setProperties() {
        statusBarView.do {
            $0.backgroundColor = .white
            $0.alpha = 0
        }
    }

    private func setLayouts() {
        addSubviews(bannerView, collectionView, statusBarView, notificationButton)
        bannerView.snp.makeConstraints { make in
            make.height.equalTo(350)
            make.leading.top.trailing.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        statusBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.top)
        }
        notificationButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.trailing.equalToSuperview().inset(8)
        }
    }

    func createWeatherDetailSectionLayout() -> NSCollectionLayoutSection {
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

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 300, leading: 12, bottom: 0, trailing: 12)
        return section
    }

    func createRecommandationSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(125),
            heightDimension: .absolute(125)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .continuous
        group.contentInsets = .init(top: .zero, leading: 12, bottom: .zero, trailing: 12)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(96)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: .zero, leading: 20, bottom: .zero, trailing: 20)
        header.contentInsets = .init(top: .zero, leading: -20, bottom: .zero, trailing: -20)
        return section
    }

    func createEmptySectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(125)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .continuous
        group.contentInsets = .init(top: .zero, leading: 12, bottom: .zero, trailing: 12)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(96)
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

    func createCardSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(302 / 375)
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
            heightDimension: .absolute(96)
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

extension HomeView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let pointOfChange: CGFloat = 30
        UIView.animate(withDuration: 0.2) {
            self.statusBarView.alpha = contentOffsetY < pointOfChange ? 0 : 1
            self.bannerView.alpha = contentOffsetY < pointOfChange ? 1 : 0
            self.notificationButton.alpha = contentOffsetY < pointOfChange ? 1 : 0
        }
        guard contentOffsetY < -39 else { return }
        let scale = 1 + ((-contentOffsetY - 39) / bannerView.frame.height)
        bannerView.transform = CGAffineTransformIdentity
        bannerView.transform = CGAffineTransformMakeScale(scale, scale)
    }
}
