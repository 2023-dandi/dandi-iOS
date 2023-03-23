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
    typealias PostCell = MyPagePostCollectionViewCell
    typealias SectionHeaderRegistration<Header: UICollectionReusableView> = UICollectionView.SupplementaryRegistration<CardHeaderView>

    typealias ProfileCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, UserProfile>
    typealias PostCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, MyPost>

    typealias CellProvider = (UICollectionView, IndexPath, Item) -> UICollectionViewCell?
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private let collectionView: UICollectionView
    private let presentingViewController: UIViewController?
    private lazy var dataSource = createDataSource()

    enum Section {
        case profile
        case feed
    }

    enum Item: Hashable {
        case profile(UserProfile)
        case post(MyPost)
    }

    // MARK: - Initialize

    init(collectionView: UICollectionView, presentingViewController: UIViewController) {
        self.collectionView = collectionView
        self.presentingViewController = presentingViewController
    }

    // MARK: - Update DataSource

    func update(user: UserProfile, feed: [MyPost]) {
        configureHeader(title: "내가 올린 게시물")

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
            cell.configure(imageURL: post.postImageUrl)
            cell.cornerRadius = 4
        }
    }
}

extension MyPageDataSource {
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
}
