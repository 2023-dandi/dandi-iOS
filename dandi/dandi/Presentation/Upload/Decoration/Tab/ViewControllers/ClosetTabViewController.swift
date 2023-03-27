//
//  ClosetTabViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

import YDS

final class ClosetTabViewController: BaseViewController {
    weak var addImageDeleagte: AddImageDelegate?

    private let closetView = ClosetView()

    private var category: [String] = []
    private var tagList: [String] = []
    private var photo: [UIImage] = []

    override func loadView() {
        view = closetView
    }

    override init() {
        super.init()
        title = "옷장"
        setCollectionView()
    }

    func update(
        category: [String],
        tagList: [String],
        photo: [UIImage]
    ) {
        self.category = category
        self.tagList = tagList
        self.photo = photo

        [closetView.categoryCollectionView,
         closetView.tagCollectionView,
         closetView.photoCollectionView].forEach {
            $0.reloadData()
        }
    }

    private func setCollectionView() {
        [closetView.categoryCollectionView,
         closetView.tagCollectionView,
         closetView.photoCollectionView].forEach {
            $0.delegate = self
            $0.dataSource = self
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ClosetTabViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection _: Int
    ) -> Int {
        switch collectionView {
        case closetView.categoryCollectionView:
            return category.count
        case closetView.tagCollectionView:
            return tagList.count
        case closetView.photoCollectionView:
            return photo.count
        default:
            break
        }

        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch collectionView {
        case closetView.categoryCollectionView:
            let cell: CategoryTextCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(text: category[indexPath.item])
            return cell

        case closetView.tagCollectionView:
            let cell: RoundTagCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(text: tagList[indexPath.item])

            return cell

        case closetView.photoCollectionView:
            let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(image: photo[indexPath.item])
            return cell

        default:
            return UICollectionViewCell()
        }
    }
}

extension ClosetTabViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch collectionView {
        case closetView.categoryCollectionView:
            print("mainCategoryTabCollectionView")
            print(indexPath)
        case closetView.tagCollectionView:
            print("tagTabCollectionView")
            print(indexPath)
        case closetView.photoCollectionView:
            print("photoCollectionView")
            print(indexPath)
            addImageDeleagte?.add(self, image: photo[indexPath.item])
        default:
            break
        }
    }
}
