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

    typealias CardCell = CardCollectionViewCell
    typealias CellProvider = (UICollectionView, IndexPath, Item) -> UICollectionViewCell?
    typealias CardCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, Post>
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    let collectionView: UICollectionView
    var presentingViewController: HomeViewController?

    lazy var dataSource = createDataSource()

    enum Section {
        case weather
        case same
        case recommendation
    }

    enum Item: Hashable {
        case post(Post)
    }

    init(collectionView: UICollectionView, presentingViewController: HomeViewController) {
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

    func update(
        same: [Post],
        recommendation: [Post]
    ) {
        var snapshot = Snapshot()
        snapshot.appendSections([.same, .recommendation])

        let sameItems = same.map { Item.post($0) }
        snapshot.appendItems(sameItems, toSection: .same)

        let recommendationItems = recommendation.map { Item.post($0) }
        snapshot.appendItems(recommendationItems, toSection: .recommendation)

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func itemIdentifier(for indexPath: IndexPath) -> Item? {
        return dataSource.itemIdentifier(for: indexPath)
    }
}
