//
//  StickerTabViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/26.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

final class StickerTabViewController: BaseViewController {
    weak var addImageDelegate: AddImageDelegate?

    private let contentView = ImagesWithAddButtonView()
    private lazy var dataSource = ImagesDataSource(collectionView: self.contentView.collectionView)

    override func loadView() {
        view = contentView
    }

    override init() {
        super.init()
        title = "스티커"
        dataSource.update(items: [
            ClosetImage(id: 1, image: Image.sticker1, imageURL: nil),
            ClosetImage(id: 2, image: Image.sticker2, imageURL: nil),
            ClosetImage(id: 3, image: Image.sticker3, imageURL: nil),
            ClosetImage(id: 4, image: Image.sticker4, imageURL: nil),
            ClosetImage(id: 5, image: Image.sticker5, imageURL: nil),
            ClosetImage(id: 6, image: Image.sticker6, imageURL: nil),
            ClosetImage(id: 7, image: Image.sticker7, imageURL: nil)
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
