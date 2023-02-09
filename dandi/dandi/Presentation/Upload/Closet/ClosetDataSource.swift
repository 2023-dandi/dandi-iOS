//
//  ClosetDataSource.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/19.
//

import UIKit

final class ClosetDataSource {
    typealias ButtonCell = AddButtonCollectionViewCell
    typealias ImageCell = ImageCollectionViewCell
    typealias ButtonCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, Int>
    typealias ImageCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, ClosetImage>

    typealias CellProvider = (UICollectionView, IndexPath, Item) -> UICollectionViewCell
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private let collectionView: UICollectionView
    private var presentingViewController: ClosetViewController?
    private lazy var dataSource = createDataSource()

    enum Section {
        case main
    }

    enum Item: Hashable {
        case button
        case image(ClosetImage)
    }

    init(
        collectionView: UICollectionView,
        presentingViewController: ClosetViewController? = nil
    ) {
        self.collectionView = collectionView
        self.presentingViewController = presentingViewController
    }

    func update(imageURLs: [ClosetImage]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])

        let buttonItems = [Item.button]
        snapshot.appendItems(buttonItems)

        let imageItems = imageURLs.map { Item.image($0) }
        snapshot.appendItems(imageItems)

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func itemIdentifier(for indexPath: IndexPath) -> Item? {
        return dataSource.itemIdentifier(for: indexPath)
    }
}

extension ClosetDataSource {
    private func createDataSource() -> DiffableDataSource {
        let buttonRegistration: ButtonCellRegistration<ButtonCell> = configureButtonCellRegistration()
        let imageRegistration: ImageCellRegistration<ImageCell> = configureImageCellRegistration()

        let cellProvider: CellProvider = { collectionView, indexPath, item in
            switch item {
            case .button:
                return collectionView.dequeueConfiguredReusableCell(
                    using: buttonRegistration,
                    for: indexPath,
                    item: indexPath.item
                )
            case let .image(image):
                return collectionView.dequeueConfiguredReusableCell(
                    using: imageRegistration,
                    for: indexPath,
                    item: image
                )
            }
        }

        return DiffableDataSource(collectionView: collectionView, cellProvider: cellProvider)
    }

    private func configureButtonCellRegistration<Cell: ButtonCell>() -> ButtonCellRegistration<Cell> {
        return ButtonCellRegistration<Cell> { cell, _, _ in
            cell.configure(type: .add)
        }
    }

    private func configureImageCellRegistration<Cell: ImageCell>() -> ImageCellRegistration<Cell> {
        return ImageCellRegistration<Cell> { cell, _, image in
            cell.configure(
                contentMode: .scaleAspectFit,
                imageURL: image.imageURL
            )
        }
    }
}
