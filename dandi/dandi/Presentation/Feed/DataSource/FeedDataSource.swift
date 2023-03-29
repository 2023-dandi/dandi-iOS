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
    typealias CardCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, Int>

    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private let collectionView: UICollectionView
    private var presentingViewController: (UIViewController & HeartButtonDelegate)?

    private lazy var dataSource = createDataSource()

    private var posts: [Int: Post] = .init()

    enum Section {
        case feed
    }

    enum Item: Hashable {
        case post(Int)
    }

    // MARK: - Initialize

    init(collectionView: UICollectionView, presentingViewController: UIViewController & HeartButtonDelegate) {
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
            cell.id = post.id
            cell.delegate = self.presentingViewController
        }
    }

    func update(feed: [Post]) {
        var snapshot = Snapshot()
        if !snapshot.sectionIdentifiers.contains(.feed) {
            snapshot.appendSections([.feed])
        }

        let ids = feed.map { $0.id }.uniqued().map { Item.post($0) }
        snapshot.appendItems(ids)

        feed
            .filter { !self.posts.keys.contains($0.id) }
            .forEach { self.posts[$0.id] = $0 }

        feed
            .filter { self.posts.keys.contains($0.id) }
            .forEach { item in
                if let oldValue = self.posts.updateValue(item, forKey: item.id),
                   oldValue != item
                {
                    snapshot.reloadItems([Item.post(item.id)])
                }
            }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func itemIdentifier(for indexPath: IndexPath) -> Post? {
        switch dataSource.itemIdentifier(for: indexPath) {
        case let .post(postID):
            return posts[postID]
        default:
            return nil
        }
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
