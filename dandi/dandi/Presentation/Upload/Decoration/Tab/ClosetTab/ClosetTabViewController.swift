//
//  ClosetTabViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import YDS

final class ClosetTabViewController: BaseViewController, View {
    typealias Reactor = ClosetTabReactor

    weak var addImageDeleagte: AddImageDelegate?

    private let closetView = ClosetTabView()

    private var categoryList: [CategoryInfo] = [] {
        didSet {
            category = categoryList.map { $0.category.text }
        }
    }

    private var selectedCategory: Int? {
        didSet {
            guard let selectedCategory = selectedCategory else { return }
            tagList = categoryList[selectedCategory].seasons.map { $0.text }
        }
    }

    private var selectedTags: [Int] = [0]

    private var selectedCategoryPublisher = PublishSubject<CategoryInfo>()

    /// DataSource
    private var category: [String] = []
    private var tagList: [String] = []
    private var imageURLList: [String] = [] {
        didSet {
            self.closetView.photoCollectionView.reloadData()
        }
    }

    override func loadView() {
        view = closetView
    }

    override init() {
        super.init()
        title = "옷장"
        setCollectionView()
    }

    func bind(reactor: Reactor) {
        bindAction(reactor)
        bindState(reactor)
    }

    private func bindAction(_ reactor: Reactor) {
        rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.fetchCategory }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        selectedCategoryPublisher
            .map { Reactor.Action.fetchClothes(category: $0.category, seasons: $0.seasons) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindState(_ reactor: Reactor) {
        reactor.state
            .compactMap { $0.category }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] categoryList in
                self?.categoryList = categoryList
                self?.selectedCategory = 0
                self?.closetView.categoryCollectionView.reloadData()
                self?.closetView.categoryCollectionView.selectItem(
                    at: IndexPath(item: 0, section: 0),
                    animated: false,
                    scrollPosition: []
                )
                self?.closetView.tagCollectionView.selectItem(
                    at: IndexPath(item: 0, section: 0),
                    animated: false,
                    scrollPosition: []
                )
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.clothes }
            .subscribe(onNext: { [weak self] clothes in
                self?.imageURLList = clothes.map { $0.imageURL }
            })
            .disposed(by: disposeBag)
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
            return imageURLList.count
        default:
            return 0
        }
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
            cell.configure(imageURL: imageURLList[indexPath.item])
            return cell

        default:
            return UICollectionViewCell()
        }
    }
}

extension ClosetTabViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        guard collectionView == closetView.tagCollectionView else { return true }

        if indexPath.item == 0 {
            collectionView.indexPathsForSelectedItems?.forEach {
                collectionView.deselectItem(at: $0, animated: false)
            }
            selectedTags = [0]
            return true
        }

        if selectedTags.contains(0) {
            selectedTags = selectedTags.filter { $0 != 0 }
            collectionView.deselectItem(at: IndexPath(item: 0, section: 0), animated: false)
            return true
        }
        return true
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch collectionView {
        case closetView.categoryCollectionView:
            selectedCategory = indexPath.item

            selectedTags = [0]
            closetView.tagCollectionView.reloadData()

            closetView.tagCollectionView.selectItem(
                at: IndexPath(item: 0, section: 0),
                animated: false,
                scrollPosition: []
            )

            selectedCategoryPublisher.onNext(
                CategoryInfo(
                    category: categoryList[indexPath.item].category,
                    seasons: [.all]
                )
            )

        case closetView.tagCollectionView:
            selectedTags.append(indexPath.item)

            guard let selectedCategory = selectedCategory else { return }
            selectedCategoryPublisher.onNext(
                CategoryInfo(
                    category: categoryList[selectedCategory].category,
                    seasons: selectedTags.compactMap { Season(rawValue: $0) }
                )
            )

        case closetView.photoCollectionView:
            guard
                let imageCell = closetView.photoCollectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell,
                let image = imageCell.imageView.image
            else {
                return
            }
            addImageDeleagte?.add(self, image: image)

        default:
            return
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        shouldDeselectItemAt _: IndexPath
    ) -> Bool {
        switch collectionView {
        case closetView.categoryCollectionView:
            return false

        case closetView.tagCollectionView:
            if selectedTags.count <= 1 {
                return false
            } else {
                return true
            }
        default:
            return true
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        guard collectionView == closetView.tagCollectionView else { return }

        selectedTags = selectedTags.filter { $0 != indexPath.item }

        guard let selectedCategory = selectedCategory else { return }
        selectedCategoryPublisher.onNext(
            CategoryInfo(
                category: categoryList[selectedCategory].category,
                seasons: selectedTags.compactMap { Season(rawValue: $0) }
            )
        )
    }
}
