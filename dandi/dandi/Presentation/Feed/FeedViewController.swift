//
//  FeedViewController.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import YDS

final class FeedViewController: BaseViewController, View {
    typealias Reactor = FeedReactor

    private let feedView: FeedView = .init()
    private lazy var feedDataSource: FeedDataSource = .init(
        collectionView: feedView.collectionView,
        presentingViewController: self
    )
    private let temperaturePublisher = PublishRelay<Temperatures>()
    private let likePublisher = PublishSubject<Int>()
    private let emptyLabel = EmptyLabel(text: "아직 참고할 수 있는 날씨 옷이 없어요.\n직접 날씨옷을 기록해보는 건 어떨까요?")

    override func loadView() {
        view = feedView
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
                owner.feedView.collectionView.isHidden = posts.isEmpty
                owner.feedDataSource.update(feed: posts)
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.temperature }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] temperature in
                guard let self = self else { return }
                self.feedView.navigationTitleLabel.text = "최고\(temperature.max)/최저\(temperature.min)에 다른 사람들은 어떤 옷을 입었는 지 둘러볼까요?"
                self.temperaturePublisher.accept(temperature)
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
        Observable.merge([
            NotificationCenterManager.reloadLocation.addObserver().map { _ in },
            rx.viewWillAppear.take(1).map { _ in }
        ])
        .map { _ in Reactor.Action.fetchTemperature }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)

        NotificationCenterManager.reloadPosts.addObserver()
            .map { _ in
                Reactor.Action.fetchPostList(
                    min: reactor.currentState.temperature?.min,
                    max: reactor.currentState.temperature?.max
                )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        temperaturePublisher
            .map { Reactor.Action.fetchPostList(min: $0.min, max: $0.max) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        likePublisher
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { Reactor.Action.like(id: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindTabAction() {
        feedView.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                guard let post = owner.feedDataSource.itemIdentifier(for: indexPath) else { return }
                owner.navigationController?.pushViewController(
                    owner.factory.makePostDetailViewController(postID: post.id),
                    animated: true
                )
            })
            .disposed(by: disposeBag)

        feedView.locationButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let vc = owner.factory.makeLocationSettingViewController(from: .default)
                owner.present(YDSNavigationController(rootViewController: vc), animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setLayouts() {
        emptyLabel.isHidden = true
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension FeedViewController: HeartButtonDelegate {
    func buttonDidTap(postID: Int) {
        likePublisher.onNext(postID)
        NotificationCenterManager.reloadPost.post(object: postID)
    }
}
