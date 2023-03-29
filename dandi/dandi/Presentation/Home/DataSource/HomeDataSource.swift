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

    typealias WeatherDetailCell = WeatherDetailCollectionViewCell
    typealias ClothesCell = ImageCollectionViewCell
    typealias CardCell = CardCollectionViewCell

    typealias WeahterDetailCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, TimeWeatherInfo>
    typealias ClothesCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, ClosetImage>
    typealias CardCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, Int>

    typealias SectionHeaderRegistration<Header: UICollectionReusableView> = UICollectionView.SupplementaryRegistration<CardHeaderView>

    typealias CellProvider = (UICollectionView, IndexPath, Item) -> UICollectionViewCell?
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private let collectionView: UICollectionView
    private var presentingViewController: (UIViewController & HeartButtonDelegate)?

    private lazy var dataSource = createDataSource()

    private var posts: [Int: Post] = .init()

    enum Section {
        case timeWeather
        case recommendation
        case same
    }

    enum Item: Hashable {
        case timeWeatherInfo(TimeWeatherInfo)
        case recommendation(ClosetImage)
        case post(Int)
    }

    init(collectionView: UICollectionView, presentingViewController: UIViewController & HeartButtonDelegate) {
        self.collectionView = collectionView
        self.presentingViewController = presentingViewController
    }

    func update(
        recommedationText: String,
        temperature: String,
        recommendation: [ClosetImage],
        timeWeathers: [TimeWeatherInfo],
        posts: [Post]
    ) {
        var snapshot = Snapshot()
        snapshot.appendSections([.timeWeather, .recommendation, .same])

        let timeWeatherItems = timeWeathers.map { Item.timeWeatherInfo($0) }
        snapshot.appendItems(timeWeatherItems, toSection: .timeWeather)

        let recommadationItems = recommendation.map { Item.recommendation($0) }
        snapshot.appendItems(recommadationItems, toSection: .recommendation)

        let ids = posts.map { $0.id }.uniqued().map { Item.post($0) }
        snapshot.appendItems(ids)

        posts
            .filter { !self.posts.keys.contains($0.id) }
            .forEach { self.posts[$0.id] = $0 }

        posts
            .filter { self.posts.keys.contains($0.id) }
            .forEach { item in
                if let oldValue = self.posts.updateValue(item, forKey: item.id),
                   oldValue != item
                {
                    snapshot.reloadItems([Item.post(item.id)])
                }
            }

        configureHeader(headers: [
            Header(title: "오늘의 추천룩", subtitle: recommedationText),
            Header(title: temperature + "도의 내 기록", subtitle: "이전에 오늘 같은 날씨에는 이렇게 입었어요.")
        ])
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func getPostItem(id: Int) -> Post? {
        return posts[id]
    }

    func itemIdentifier(for indexPath: IndexPath) -> Item? {
        return dataSource.itemIdentifier(for: indexPath)
    }

    func reloadIfNeeded(item: Post) {
        guard
            posts.keys.contains(item.id),
            let oldValue = posts.updateValue(item, forKey: item.id),
            oldValue != item
        else { return }
        var currentSnapshot = dataSource.snapshot()
        currentSnapshot.reloadItems([Item.post(item.id)])
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

extension HomeDataSource {
    private func createDataSource() -> DiffableDataSource {
        let cardRegistration: CardCellRegistration<CardCell> = configureCardCellRegistration()
        let imageRegistration: ClothesCellRegistration<ClothesCell> = configureRecommendationCellRegistration()
        let weatherDetailRegistration: WeahterDetailCellRegistration<WeatherDetailCell> = configureDetailBannerCellRegistration()

        let cellProvider: CellProvider = { collectionView, indexPath, item in
            switch item {
            case let .post(post):
                return collectionView.dequeueConfiguredReusableCell(
                    using: cardRegistration,
                    for: indexPath,
                    item: post
                )
            case let .timeWeatherInfo(info):
                return collectionView.dequeueConfiguredReusableCell(
                    using: weatherDetailRegistration,
                    for: indexPath,
                    item: info
                )
            case let .recommendation(item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: imageRegistration,
                    for: indexPath,
                    item: item
                )
            }
        }
        return DiffableDataSource(
            collectionView: collectionView,
            cellProvider: cellProvider
        )
    }

    private func configureCardCellRegistration<Cell: CardCell>() -> CardCellRegistration<Cell> {
        return CardCellRegistration<Cell> { [weak self] cell, _, postID in
            guard
                let self = self,
                let post = self.posts[postID]
            else { return }
            cell.configure(
                mainImageURL: post.mainImageURL,
                profileImageURL: post.profileImageURL,
                nickname: post.nickname,
                content: post.content,
                date: post.date,
                isLiked: post.isLiked
            )
            cell.id = postID
            cell.delegate = self.presentingViewController
        }
    }

    private func configureRecommendationCellRegistration<Cell: ClothesCell>() -> ClothesCellRegistration<Cell> {
        return ClothesCellRegistration<Cell> { cell, _, _ in
            cell.type = .none
            cell.configure(image: Image.background4)
        }
    }

    private func configureDetailBannerCellRegistration<Cell: WeatherDetailCell>() -> WeahterDetailCellRegistration<Cell> {
        return WeahterDetailCellRegistration<Cell> { cell, _, info in
            cell.configure(
                mainImage: info.image,
                time: info.time,
                temperature: info.temperature
            )
        }
    }

    struct Header {
        let title: String
        let subtitle: String
    }

    private func configureHeader(headers: [Header]) {
        let headerRegistration = SectionHeaderRegistration<CardHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { headerView, _, indexPath in
            switch indexPath.section {
            case 1:
                headerView.configure(title: headers[0].title, subtitle: headers[0].subtitle)
            case 2:
                headerView.configure(title: headers[1].title, subtitle: headers[1].subtitle)
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
}
