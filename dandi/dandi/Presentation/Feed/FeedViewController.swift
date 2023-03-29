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

    override func loadView() {
        view = feedView
    }

    override init() {
        super.init()
    }

    func bind(reactor: Reactor) {
        bindState(reactor)
        bindAction(reactor)
        bindTabAction()
    }

    private func bindState(_ reactor: Reactor) {
        reactor.state
            .compactMap { $0.posts }
            .withUnretained(self)
            .subscribe(onNext: { owner, posts in
                owner.feedDataSource.update(feed: posts)
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.temperature }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] temperature in
                guard let self = self else { return }
                self.feedView.navigationTitleLabel.text = "\(UserDefaultHandler.shared.address)은 최고\(temperature.max)/최저\(temperature.min)도입니다."
                self.temperaturePublisher.accept(temperature)
            })
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
    }

    private func bindTabAction() {
        feedView.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                switch owner.feedDataSource.itemIdentifier(for: indexPath) {
                case let .post(post):
                    owner.navigationController?.pushViewController(
                        owner.factory.makePostDetailViewController(postID: post.id),
                        animated: true
                    )
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        feedView.locationButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let vc = owner.factory.makeLocationSettingViewController()
                owner.present(YDSNavigationController(rootViewController: vc), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
