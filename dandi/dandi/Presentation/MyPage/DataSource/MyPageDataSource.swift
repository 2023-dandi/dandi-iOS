//
//  MyPageDataSource.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/08.
//

import UIKit

import RxCocoa
import RxSwift

final class MyPageDataSource {
    // MARK: - typealias

    typealias ProfileCell = MyPageProfileCollectionViewCell
    typealias PostCell = ImageCollectionViewCell

    typealias ProfileCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, UserProfile>
    typealias PostCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, Post>

    typealias CellProvider = (UICollectionView, IndexPath, Item) -> UICollectionViewCell?
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private let collectionView: UICollectionView
    private var presentingViewController: UIViewController?
    private lazy var dataSource = createDataSource()

    enum Section {
        case profile
        case feed
    }

    enum Item: Hashable {
        case profile(UserProfile)
        case post(Post)
    }

    // MARK: - Initialize

    init(collectionView: UICollectionView, presentingViewController: UIViewController) {
        self.collectionView = collectionView
        self.presentingViewController = presentingViewController
    }

    // MARK: - Update DataSource

    func update(user: UserProfile, feed: [Post]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.profile, .feed])

        let userItem = Item.profile(user)
        snapshot.appendItems([userItem], toSection: .profile)

        let feedItems = feed.map { Item.post($0) }
        snapshot.appendItems(feedItems, toSection: .feed)

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func itemIdentifier(for indexPath: IndexPath) -> Item? {
        return dataSource.itemIdentifier(for: indexPath)
    }
}

extension MyPageDataSource {
    private func createDataSource() -> DiffableDataSource {
        let profileRegistration: ProfileCellRegistration<ProfileCell> = configureProfileCellRegistration()
        let postRegistration: PostCellRegistration<PostCell> = configurePostCellRegistration()

        let cellProvider: CellProvider = { collectionView, indexPath, item in
            switch item {
            case let .profile(profile):
                return collectionView.dequeueConfiguredReusableCell(
                    using: profileRegistration,
                    for: indexPath,
                    item: profile
                )
            case let .post(post):
                return collectionView.dequeueConfiguredReusableCell(
                    using: postRegistration,
                    for: indexPath,
                    item: post
                )
            }
        }
        return DiffableDataSource(collectionView: collectionView, cellProvider: cellProvider)
    }
}

extension MyPageDataSource {
    private func configureProfileCellRegistration<Cell: ProfileCell>() -> ProfileCellRegistration<Cell> {
        return ProfileCellRegistration<Cell> { cell, _, profile in
            cell.configure(
                profileImageURL: profile.profileImageURL,
                nickname: profile.nickname,
                location: profile.location,
                closetCount: profile.closetCount
            )
        }
    }

    private func configurePostCellRegistration<Cell: PostCell>() -> PostCellRegistration<Cell> {
        return PostCellRegistration<Cell> { cell, _, post in
            cell.configure(
                contentMode: .scaleAspectFill,
                imageURL: post.mainImageURL
            )
            cell.cornerRadius = 4
        }
    }
}
