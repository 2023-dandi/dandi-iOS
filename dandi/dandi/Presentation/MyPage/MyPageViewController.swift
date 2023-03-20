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
        bindCollectionView()
        bindState(reactor)
        bindAction(reactor)
    }

    private func bindState(_ reactor: MyPageReactor) {
        reactor.state
            .compactMap { $0.profile }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, profile in
                owner.myPageDataSource.update(user: profile, feed: [])
            })
            .disposed(by: disposeBag)
    }

    private func bindAction(_ reactor: MyPageReactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.fetchProfile }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindCollectionView() {
        myPageView.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                switch owner.myPageDataSource.itemIdentifier(for: indexPath) {
                case .profile:
                    owner.navigationController?.pushViewController(
                        owner.factory.makeMyInformationViewController(),
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
