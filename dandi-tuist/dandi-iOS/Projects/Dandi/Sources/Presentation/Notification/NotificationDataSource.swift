//
//  NotificationDataSource.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/28.
//

import UIKit

import RxCocoa
import RxSwift

final class NotificationDataSource {
    // MARK: - typealias

    typealias NotificationCell = NotificationCollectionViewCell

    typealias NotificationCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, NotificationItem>

    typealias CellProvider = (UICollectionView, IndexPath, NotificationItem) -> UICollectionViewCell?
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, NotificationItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, NotificationItem>

    private let collectionView: UICollectionView

    private lazy var dataSource = createDataSource()

    enum Section {
        case main
    }

    // MARK: - Initialize

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    // MARK: - Update DataSource

    func update(list: [NotificationItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(list)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func itemIdentifier(for indexPath: IndexPath) -> NotificationItem? {
        return dataSource.itemIdentifier(for: indexPath)
    }
}

extension NotificationDataSource {
    private func createDataSource() -> DiffableDataSource {
        let profileRegistration: NotificationCellRegistration<NotificationCell> = configureNotificationCellRegistration()

        let cellProvider: CellProvider = { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: profileRegistration,
                for: indexPath,
                item: item
            )
        }
        return DiffableDataSource(collectionView: collectionView, cellProvider: cellProvider)
    }
}

extension NotificationDataSource {
    private func configureNotificationCellRegistration<Cell: NotificationCell>() -> NotificationCellRegistration<Cell> {
        return NotificationCellRegistration<Cell> { cell, _, item in
            cell.configure(
                type: item.type,
                title: item.title,
                description: item.description
            )
        }
    }
}
