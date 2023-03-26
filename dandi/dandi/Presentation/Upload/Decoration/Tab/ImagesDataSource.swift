//
//  ImagesDataSource.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/26.
//

import UIKit

import YDS

final class ImagesDataSource {
    typealias ButtonCell = ImageCollectionViewCell
    typealias ImageCell = ImageCollectionViewCell
    typealias ButtonCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, Int>
    typealias ImageCellRegistration<Cell: UICollectionViewCell> = UICollectionView.CellRegistration<Cell, ClosetImage>

    typealias CellProvider = (UICollectionView, IndexPath, Item) -> UICollectionViewCell
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private let collectionView: UICollectionView
    private lazy var dataSource = createDataSource()

    enum Section {
        case main
    }

    enum Item: Hashable {
        case button
        case image(ClosetImage)
    }

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    func update(items: [ClosetImage]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])

        let buttonItems = [Item.button]
        snapshot.appendItems(buttonItems)

        let imageItems = items.map { Item.image($0) }
        snapshot.appendItems(imageItems)

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func itemIdentifier(for indexPath: IndexPath) -> Item? {
        return dataSource.itemIdentifier(for: indexPath)
    }
}

extension ImagesDataSource {
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
            cell.contentMode = .center
            cell.configure(
                image: YDSIcon.plusLine
                    .withRenderingMode(.alwaysOriginal)
                    .withTintColor(YDSColor.buttonNormal)
                    .resize(newWidth: 24)
            )
        }
    }

    private func configureImageCellRegistration<Cell: ImageCell>() -> ImageCellRegistration<Cell> {
        return ImageCellRegistration<Cell> { cell, _, item in
            cell.contentMode = .scaleAspectFill
            if let image = item.image {
                cell.configure(image: image)
            }
            if let imageURL = item.imageURL {
                cell.configure(imageURL: imageURL)
            }
        }
    }
}
