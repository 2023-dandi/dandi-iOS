//
//  BackgroundTabViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/26.
//

import UIKit

final class BackgroundTabViewController: BaseViewController {
    weak var addImageDelegate: AddImageDelegate?

    private let contentView = ImagesWithAddButtonView()
    private lazy var dataSource = ImagesDataSource(collectionView: self.contentView.collectionView)

    private let backgroundImages = [
        Image.background1,
        Image.background2,
        Image.background3,
        Image.background4,
        Image.background5,
        Image.background6,
        Image.background7
    ]

    private let stickerImages = [
        Image.sticker1,
        Image.sticker2,
        Image.sticker3,
        Image.sticker4,
        Image.sticker5,
        Image.sticker6,
        Image.sticker7
    ]

    override func loadView() {
        view = contentView
    }

    override init() {
        super.init()
        title = "배경"
        dataSource.update(items: [
            ClosetImage(id: 1, image: Image.background1, imageURL: nil),
            ClosetImage(id: 2, image: Image.background2, imageURL: nil),
            ClosetImage(id: 3, image: Image.background3, imageURL: nil),
            ClosetImage(id: 4, image: Image.background4, imageURL: nil),
            ClosetImage(id: 5, image: Image.background5, imageURL: nil),
            ClosetImage(id: 6, image: Image.background6, imageURL: nil),
            ClosetImage(id: 7, image: Image.background7, imageURL: nil)
        ])

        bind()
    }

    private func bind() {
        contentView.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                switch owner.dataSource.itemIdentifier(for: indexPath) {
                case let .image(item):
                    guard let image = item.image else { return }
                    owner.addImageDelegate?.add(self, image: image)
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
    }
}
