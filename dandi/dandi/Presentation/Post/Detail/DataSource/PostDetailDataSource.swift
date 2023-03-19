//
//  PostDetailDataSource.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/13.
//

import UIKit

import RxSwift

final class PostDetailDataSource {
    typealias ContentCell = PostContentCollectionViewCell
    typealias CommentCell = PostCommentCollectionViewCell
    typealias TagCell = TagCollectionViewCell

    typealias ContentCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, Post>
    typealias CommentCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, Comment>
    typealias TagCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, WeatherFeeling>

    typealias CellProvider = (UICollectionView, IndexPath, Item) -> UICollectionViewCell?

    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>

    private lazy var dataSource = createDataSource()

    private let collectionView: UICollectionView

    enum Section {
        case post
        case tag
        case comment
    }

    enum Item: Hashable {
        case post(Post)
        case tag(WeatherFeeling)
        case comment(Comment)
    }

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    func update(
        post: Post,
        comments: [Comment]
    ) {
        var snapshot = Snapshot()
        snapshot.appendSections([.post, .tag, .comment])

        let postItem = [Item.post(post)]
        let tagItem = post.tag.map { Item.tag($0) }
        let commentItems = comments.map { Item.comment($0) }

        snapshot.appendItems(postItem, toSection: .post)
        snapshot.appendItems(tagItem, toSection: .tag)
        snapshot.appendItems(commentItems, toSection: .comment)

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func itemIdentifier(for indexPath: IndexPath) -> Item? {
        return dataSource.itemIdentifier(for: indexPath)
    }

    func commentItemIdentifier(for indexPath: IndexPath) -> Comment? {
        switch dataSource.itemIdentifier(for: indexPath) {
        case let .comment(comment):
            return comment
        default:
            return nil
        }
    }

    private func createDataSource() -> DiffableDataSource {
        let contentRegistration: ContentCellRegistration<ContentCell> = configureContentCell()
        let commentRegistration: CommentCellRegistration<CommentCell> = configureCommentCell()
        let tagRegistration: TagCellRegistration<TagCell> = configureTagCell()

        let cellProvider: CellProvider = { collectionView, indexPath, item in
            switch item {
            case let .tag(item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: tagRegistration,
                    for: indexPath,
                    item: item
                )
            case let .post(item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: contentRegistration,
                    for: indexPath,
                    item: item
                )
            case let .comment(item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: commentRegistration,
                    for: indexPath,
                    item: item
                )
            }
        }
        return UICollectionViewDiffableDataSource<Section, Item>(
            collectionView: collectionView,
            cellProvider: cellProvider
        )
    }

    private func configureContentCell<Cell: ContentCell>() -> ContentCellRegistration<Cell> {
        return ContentCellRegistration<Cell> { cell, _, post in
            cell.configure(post: post)
        }
    }

    private func configureCommentCell<Cell: CommentCell>() -> CommentCellRegistration<Cell> {
        return CommentCellRegistration<Cell> { cell, _, comment in
            cell.configure(
                profileImageURL: comment.profileImageURL,
                nickname: comment.nickname,
                content: comment.content,
                date: comment.date,
                isMine: comment.isMine
            )
        }
    }

    private func configureTagCell<Cell: TagCell>() -> TagCellRegistration<Cell> {
        return TagCellRegistration<Cell> { cell, _, tag in
            cell.configure(text: tag.text)
            cell.isUserInteractionEnabled = false
        }
    }
}
