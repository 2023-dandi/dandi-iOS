//
//  ClosetViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/15.
//

import UIKit

import RxCocoa
import RxSwift
import YPImagePicker

final class ClosetViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private let closetView: ClosetView = .init()
    private lazy var datasource: ClosetDataSource = .init(collectionView: closetView.collectionView)
    private var imageList = [UIImage]() {
        didSet {
            isDisabledPhotoButton(imageList.count >= 10)
        }
    }

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
                    let library = owner.factory.makePhotoLibraryViewController(maxNumberOfItems: 7)
                    library.modalPresentationStyle = .fullScreen
                    library.didFinishPicking { [unowned library] items, cancelled in
                        guard
                            !cancelled,
                            let firstItem = items.first
                        else {
                            library.dismiss(animated: true, completion: nil)
                            return
                        }

                        switch firstItem {
                        case .photo:
                            items.forEach { self.addImage($0) }
                        default:
                            break
                        }
                        library.dismiss(animated: true)
                    }
                    owner.present(library, animated: true)
                case let .image(image):
                    DandiLog.debug(image)
                case .none:
                    DandiLog.error("해당 Item 없음")
                }
            })
            .disposed(by: disposeBag)

        closetView.backButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func isDisabledPhotoButton(_ isDisabled: Bool) {
        let indexPath = IndexPath(item: 0, section: 0)
        guard
            let cell = closetView.collectionView.cellForItem(at: indexPath) as? AddButtonCollectionViewCell
        else {
            return
        }
        cell.isDisabled = isDisabled
    }

    private func addImage(_ item: YPMediaItem) {
        guard let image = convertItemToImage(with: item) else { return }
        imageList.append(image)
    }

    private func convertItemToImage(with item: YPMediaItem) -> UIImage? {
        switch item {
        case let .photo(photo):
            return photo.image
        default:
            return nil
        }
    }
}
