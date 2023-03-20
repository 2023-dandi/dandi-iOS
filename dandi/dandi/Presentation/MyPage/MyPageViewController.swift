//
//  MyPageViewController.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class MyPageViewController: BaseViewController, View {
    typealias Reactor = MyPageReactor

    private let myPageView: MyPageView = .init()
    private lazy var myPageDataSource: MyPageDataSource = .init(
        collectionView: myPageView.collectionView,
        presentingViewController: self
    )

    override func loadView() {
        view = myPageView
    }

    override init() {
        super.init()
    }

    func bind(reactor: MyPageReactor) {
        bindCollectionView(reactor)
        bindState(reactor)
        bindAction(reactor)
    }

    private func bindState(_ reactor: MyPageReactor) {
        reactor.state
            .compactMap { $0.profile }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, profile in
                dump(profile)
                owner.myPageDataSource.update(user: profile, feed: [])
            })
            .disposed(by: disposeBag)
    }

    private func bindAction(_ reactor: MyPageReactor) {
        rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.fetchProfile }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindCollectionView(_ reactor: MyPageReactor) {
        myPageView.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                switch owner.myPageDataSource.itemIdentifier(for: indexPath) {
                case .profile:
                    guard let profile = reactor.currentState.profile else { return }
                    owner.navigationController?.pushViewController(
                        owner.factory.makeMyInformationViewController(userProfile: profile),
                        animated: true
                    )
                case let .post(post):
                    owner.navigationController?.pushViewController(
                        owner.factory.makePostDetailViewController(postID: post.id),
                        animated: true
                    )
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
