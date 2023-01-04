//
//  HomeDataSource.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/03.
//

import UIKit

import RxCocoa
import RxSwift

final class HomeDataSource {
    // MARK: - typealias

    typealias WeatherBannerCell = WeatherBannerCollectionViewCell
    typealias CardCell = CardCollectionViewCell
    typealias CellProvider = (UICollectionView, IndexPath, Item) -> UICollectionViewCell?
    typealias CardCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, Post>
    typealias WeatherBannerCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, DayWeatherInfo>
    typealias SectionHeaderRegistration<Header: UICollectionReusableView> = UICollectionView.SupplementaryRegistration<CardHeaderView>

    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    let collectionView: UICollectionView
    var presentingViewController: HomeViewController?

    lazy var dataSource = createDataSource()

    enum Section {
        case dayWeather
        case timeWeather
        case banner
        case same
        case recommendation
    }

    enum Item: Hashable {
        case dayWeatherInfo(DayWeatherInfo)
        case post(Post)
    }

    init(collectionView: UICollectionView, presentingViewController: HomeViewController) {
        self.collectionView = collectionView
        self.presentingViewController = presentingViewController
    }

    private func createDataSource() -> DiffableDataSource {
        let cardRegistration: CardCellRegistration<CardCell> = configureCardCellRegistration()
        let weatherBannerRegistration: WeatherBannerCellRegistration<WeatherBannerCell> = configureWeatherBannerCellRegistration()
        let cellProvider: CellProvider = { collectionView, indexPath, item in
            switch item {
            case let .post(post):
                return collectionView.dequeueConfiguredReusableCell(
                    using: cardRegistration,
                    for: indexPath,
                    item: post
                )
            case let .dayWeatherInfo(info):
                return collectionView.dequeueConfiguredReusableCell(
                    using: weatherBannerRegistration,
                    for: indexPath,
                    item: info
                )
            }
        }
        return DiffableDataSource(collectionView: collectionView, cellProvider: cellProvider)
    }

    private func configureCardCellRegistration<Cell: CardCell>() -> CardCellRegistration<Cell> {
        return CardCellRegistration<Cell> { cell, _, post in
            cell.configure(
                mainImageURL: post.mainImageURL,
                profileImageURL: post.profileImageURL,
                nickname: post.nickname,
                content: post.content,
                date: post.date,
                isLiked: post.isLiked
            )
        }
    }

    private func configureWeatherBannerCellRegistration<Cell: WeatherBannerCell>() -> WeatherBannerCellRegistration<Cell> {
        return WeatherBannerCellRegistration<Cell> { cell, _, info in
            cell.configure(
                mainImageURL: info.mainImageURL,
                date: info.date,
                content: info.detail
            )
        }
    }

    private func configureHeader(title: String) {
        let headerRegistration = SectionHeaderRegistration<CardHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { headerView, _, indexPath in
            switch indexPath.section {
            case 1:
                headerView.configure(title: title)
            default:
                return
            }
        }

        dataSource.supplementaryViewProvider = { [weak self] _, _, indexPath in
            let header = self?.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
            return header
        }
    }

    func update(
        dayWeathers: [DayWeatherInfo],
        same: [Post]
    ) {
        configureHeader(title: "오늘 같은 날에는 이렇게  입었어요.")

        var snapshot = Snapshot()
        snapshot.appendSections([.dayWeather, .same])

        let dayWeatherItems = dayWeathers.map { Item.dayWeatherInfo($0) }
        snapshot.appendItems(dayWeatherItems, toSection: .dayWeather)

        let sameItems = same.map { Item.post($0) }
        snapshot.appendItems(sameItems, toSection: .same)

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func itemIdentifier(for indexPath: IndexPath) -> Item? {
        return dataSource.itemIdentifier(for: indexPath)
    }
}
