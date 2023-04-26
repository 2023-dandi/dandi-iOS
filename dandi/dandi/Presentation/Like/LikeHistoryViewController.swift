//
//  LikeHistoryViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/26.
//

import UIKit

import ReactorKit
import RxSwift

final class LikeHistoryViewController: BaseViewController, View {
    typealias Reactor = LikeHistoryReactor

    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private let historyView: LikeHistoryView = .init()
    private lazy var feedDataSource: FeedDataSource = .init(
        collectionView: historyView.collectionView,
        presentingViewController: self
    )

    private let likePublisher = PublishSubject<Int>()
    private let emptyLabel = EmptyLabel(text: "아직 좋아요한 게시글이 없어요!")

    override func loadView() {
        view = historyView
    }

    override init() {
        super.init()
        setLayouts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    func bind(reactor: Reactor) {
        bindState(reactor)
        bindAction(reactor)
        bindTabAction()
    }

    private func bindState(_ reactor: Reactor) {
        reactor.state
            .compactMap { $0.posts }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, posts in
                owner.emptyLabel.isHidden = !posts.isEmpty
                owner.historyView.collectionView.isHidden = posts.isEmpty
                owner.feedDataSource.update(feed: posts)
            })
            .disposed(by: disposeBag)

        NotificationCenterManager.reloadPost.addObserver()
            .map { postID in
                guard let postID = postID as? Int else { return nil }
                return postID
            }
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe(onNext: { owner, likedPostID in
                guard let oldPostItem = owner.feedDataSource.getPostItem(id: likedPostID) else { return }
                let newPostItem = Post(
                    id: oldPostItem.id,
                    mainImageURL: oldPostItem.mainImageURL,
                    profileImageURL: oldPostItem.profileImageURL,
                    writerId: oldPostItem.writerId,
                    nickname: oldPostItem.nickname,
                    date: oldPostItem.date,
                    content: oldPostItem.content,
                    tag: oldPostItem.tag,
                    isLiked: !oldPostItem.isLiked,
                    isMine: oldPostItem.isMine
                )
                owner.feedDataSource.reloadIfNeeded(item: newPostItem)
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.likedPostID }
            .distinctUntilChanged()
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func bindAction(_ reactor: Reactor) {
        likePublisher
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { Reactor.Action.like(id: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        rx.viewWillAppear
            .take(1)
            .map { _ in }
            .map { Reactor.Action.fetchPostList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindTabAction() {
        historyView.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                guard let post = owner.feedDataSource.itemIdentifier(for: indexPath) else { return }
                owner.navigationController?.pushViewController(
                    owner.factory.makePostDetailViewController(postID: post.id),
                    animated: true
                )
            })
            .disposed(by: disposeBag)
    }

    private func setLayouts() {
        title = "좋아요 기록"
        emptyLabel.isHidden = true
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension LikeHistoryViewController: HeartButtonDelegate {
    func buttonDidTap(postID: Int) {
        likePublisher.onNext(postID)
        NotificationCenterManager.reloadPost.post(object: postID)
    }
}
