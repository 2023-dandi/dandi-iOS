//
//  ClosetMainViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/27.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import YDS

final class ClosetMainViewController: BaseViewController, View {
    typealias Reactor = ClosetTabReactor

    private var categoryList: [CategoryInfo] = [] {
        didSet {
            category = categoryList.map { $0.category }
        }
    }

    private var selectedCategory: Int = 0 {
        didSet {
            if selectedCategory < categoryList.count {
                tagList = categoryList[selectedCategory].seasons
            }
        }
    }

    private var selectedTags: [Season] = [.all] {
        didSet {
            selectedTags = selectedTags.uniqued()
        }
    }

    private var selectedCategoryPublisher = PublishSubject<CategoryInfo>()
    private var shouledLoadClothesPublisher = PublishSubject<Bool>()

    private let closetView = ClosetView()
    private let emptyLabel = EmptyLabel(text: "아직 등록된 옷이 없어요.\n'+' 아이콘을 눌러 옷을 등록할 수 있어요.")
    private let addButton: UIButton = .init()

    /// DataSource
    private var category: [ClothesCategory] = [] {
        didSet {
            closetView.categoryCollectionView.reloadData()
        }
    }

    private var tagList: [Season] = [] {
        didSet {
            tagList = tagList.uniqued()
            closetView.tagCollectionView.reloadData()
        }
    }

    private var clothes: [Clothes] = [] {
        didSet {
            self.closetView.photoCollectionView.reloadData()
            self.emptyLabel.isHidden = !clothes.isEmpty
        }
    }

    override func loadView() {
        view = closetView
    }

    override init() {
        super.init()
        setCollectionView()
        setProperties()
        setLayouts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    func bind(reactor: Reactor) {
        bindAction(reactor)
        bindState(reactor)
    }

    private func bindAction(_ reactor: Reactor) {
        let viewWillAppear = rx.viewWillAppear.map { _ in }.share()
        let reload = NotificationCenterManager.reloadCloset.addObserver().map { _ in }.share()

        Observable.merge([
            reload, viewWillAppear.take(1)
        ])
        .map { Reactor.Action.fetchCategory }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)

        shouledLoadClothesPublisher
            .filter { $0 }
            .map { _ in Reactor.Action.fetchClothes(category: .all, seasons: [.all]) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                self?.setCollectionViewSelectItem()
            })
            .disposed(by: disposeBag)

        selectedCategoryPublisher
            .distinctUntilChanged()
            .map { Reactor.Action.fetchClothes(category: $0.category, seasons: $0.seasons) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        addButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.addButton.transform = CGAffineTransform(rotationAngle: 180)
                let vc = owner.factory.makeHomeButtonViewController()
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.rotationDelegate = self
                vc.controllerDelegate = self
                owner.present(vc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    private func bindState(_ reactor: Reactor) {
        reactor.state
            .compactMap { $0.category }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] categoryList in
                if categoryList.isEmpty {
                    self?.categoryList = []
                    self?.tagList = []
                    self?.clothes = []
                    return
                }
                self?.categoryList = categoryList
                self?.selectedCategory = 0
                self?.setCollectionViewSelectItem()
                self?.shouledLoadClothesPublisher.onNext(true)
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.clothes }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] clothes in
                self?.clothes = clothes
            })
            .disposed(by: disposeBag)
    }

    private func setCollectionViewSelectItem() {
        closetView.categoryCollectionView.reloadData()

        closetView.categoryCollectionView.selectItem(
            at: IndexPath(item: selectedCategory, section: 0),
            animated: false,
            scrollPosition: []
        )

        selectedTags.forEach { _ in
            closetView.tagCollectionView.selectItem(
                at: IndexPath(item: 0, section: 0),
                animated: false,
                scrollPosition: []
            )
        }
    }

    private func setProperties() {
        addButton.do {
            $0.cornerRadius = 30
            $0.backgroundColor = YDSColor.buttonPoint
            $0.setImage(
                YDSIcon.plusLine
                    .withRenderingMode(.alwaysOriginal)
                    .withTintColor(.white),
                for: .normal
            )
        }
    }

    private func setLayouts() {
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(60)
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
}

extension ClosetMainViewController: UICollectionViewDataSource {
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
            return clothes.count
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
            let cell: PagerCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(text: category[indexPath.item].text)
            return cell

        case closetView.tagCollectionView:
            let cell: RoundTagCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(text: tagList[indexPath.item].text)
            return cell

        case closetView.photoCollectionView:
            let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(imageURL: clothes[indexPath.item].imageURL)
            cell.type = .none
            return cell

        default:
            return UICollectionViewCell()
        }
    }
}

extension ClosetMainViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        guard collectionView == closetView.tagCollectionView else { return true }

        if indexPath.item == 0 {
            collectionView.indexPathsForSelectedItems?.forEach {
                collectionView.deselectItem(at: $0, animated: false)
            }
            selectedTags = [.all]
            return true
        }

        if selectedTags.contains(.all) {
            selectedTags = selectedTags.filter { $0 != .all }
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

            selectedTags = [.all]

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
            selectedTags.append(tagList[indexPath.item])

            selectedCategoryPublisher.onNext(
                CategoryInfo(
                    category: categoryList[selectedCategory].category,
                    seasons: selectedTags
                )
            )

        case closetView.photoCollectionView:
            let vc = factory.makeDetailClothesViewController(id: clothes[indexPath.item].id)
            closetView.tagCollectionView.indexPathsForSelectedItems?.forEach {
                closetView.tagCollectionView.deselectItem(at: $0, animated: false)
            }
            closetView.categoryCollectionView.indexPathsForSelectedItems?.forEach {
                closetView.categoryCollectionView.deselectItem(at: $0, animated: false)
            }
            selectedCategory = 0
            navigationController?.pushViewController(vc, animated: true)

        default:
            break
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

        selectedTags = selectedTags.filter { $0 != tagList[indexPath.item] }

        selectedCategoryPublisher.onNext(
            CategoryInfo(
                category: categoryList[selectedCategory].category,
                seasons: selectedTags
            )
        )
    }
}

extension ClosetMainViewController: RotaionDelegate {
    func rotate() {
        addButton.transform = CGAffineTransform(rotationAngle: 0)
    }
}

extension ClosetMainViewController: ViewControllerDelegate {
    func presentViewController(_ viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated)
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
}
