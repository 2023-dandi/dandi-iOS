//
//  ClosetViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/15.
//

import UIKit

import RxCocoa
import RxSwift

final class ClosetViewController: BaseViewController {
    private let closetView: ClosetView = .init()
    private lazy var datasource: ClosetDataSource = .init(collectionView: closetView.collectionView)

    override func loadView() {
        view = closetView
    }

    override init() {
        super.init()
        datasource.update(
            imageURLs: [
                ClosetImage(id: 1, imageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2"),
                ClosetImage(id: 2, imageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2"),
                ClosetImage(id: 3, imageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2"),
                ClosetImage(id: 4, imageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2"),
                ClosetImage(id: 5, imageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2")
            ])
        bind()
    }

    func bind() {
        closetView.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let item = owner.datasource.itemIdentifier(for: indexPath)
                switch item {
                case .button:
                    owner.navigationController?.pushViewController(
                        owner.factory.makePhotoLibraryViewController(),
                        animated: true
                    )
                case let .image(image):
                    DandiLog.debug(image)
                case .none:
                    DandiLog.error("해당 Item 없음")
                }
            })
            .disposed(by: disposeBag)
    }
}
