//
//  FeedDataSource.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/04.
//

import UIKit

import RxCocoa
import RxSwift

final class FeedDataSource {
    // MARK: - typealias

    typealias CardCell = CardCollectionViewCell
    typealias CellProvider = (UICollectionView, IndexPath, Item) -> UICollectionViewCell?
    typealias CardCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, Post>

    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private let collectionView: UICollectionView
    private var presentingViewController: UIViewController?

    private lazy var dataSource = createDataSource()

    enum Section {
        case feed
    }

    enum Item: Hashable {
        case post(Post)
    }

    init(collectionView: UICollectionView, presentingViewController: UIViewController) {
        self.collectionView = collectionView
        self.presentingViewController = presentingViewController
    }

    private func createDataSource() -> DiffableDataSource {
        let cardRegistration: CardCellRegistration<CardCell> = configureCardCellRegistration()
        let cellProvider: CellProvider = { collectionView, indexPath, item in
            switch item {
            case let .post(post):
                return collectionView.dequeueConfiguredReusableCell(
                    using: cardRegistration,
                    for: indexPath,
                    item: post
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

    func update(feed: [Post]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.feed])
        let feedItems = feed.map { Item.post($0) }
        snapshot.appendItems(feedItems, toSection: .feed)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func itemIdentifier(for indexPath: IndexPath) -> Item? {
        return dataSource.itemIdentifier(for: indexPath)
    }
}
