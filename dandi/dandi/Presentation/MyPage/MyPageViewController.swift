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
import YDS

final class MyPageViewController: BaseViewController, View {
    typealias Reactor = MyPageReactor

    private let rightTopButton = YDSTopBarButton(image: Image.settingLine)
    private let myPageView: MyPageView = .init()
    private lazy var myPageDataSource: MyPageDataSource = .init(
        collectionView: myPageView.collectionView,
        presentingViewController: self
    )

    private var profile = UserProfile()
    private var posts: [MyPost] = [] {
        didSet {
            emptyLabel.isHidden = !posts.isEmpty
            myPageView.collectionView.bounces = !posts.isEmpty
        }
    }

    private let emptyLabel = EmptyLabel(text: "아직 작성한 날씨옷이 없어요!\n홈에서 '+' 아이콘을 눌러 날씨옷을 기록해보세요.")

    override func loadView() {
        view = myPageView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override init() {
        super.init()
        setProperties()
        setLayouts()
    }

    func bind(reactor: MyPageReactor) {
        bindCollectionView(reactor)
        bindState(reactor)
        bindAction(reactor)
        bindTapAction()
    }

    private func bindState(_ reactor: MyPageReactor) {
        reactor.state
            .compactMap { $0.profile }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, profile in
                owner.profile = profile
                owner.myPageDataSource.update(user: owner.profile, feed: owner.posts)
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.posts }
            .withUnretained(self)
            .subscribe(onNext: { owner, posts in
                owner.posts = posts
                owner.myPageDataSource.update(user: owner.profile, feed: owner.posts)
            })
            .disposed(by: disposeBag)
    }

    private func bindAction(_ reactor: MyPageReactor) {
        Observable.merge([
            rx.viewWillAppear.take(1).map { _ in },
            NotificationCenterManager.reloadProfile.addObserver().map { _ in },
            NotificationCenterManager.reloadLocation.addObserver().map { _ in }
        ])
        .map { _ in Reactor.Action.fetchProfile }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)

        Observable.merge([
            NotificationCenterManager.reloadPosts.addObserver().map { _ in },
            rx.viewWillAppear.take(1).map { _ in }
        ])
        .map { _ in Reactor.Action.fetchMyPosts }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }

    private func bindCollectionView(_: MyPageReactor) {
        myPageView.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                switch owner.myPageDataSource.itemIdentifier(for: indexPath) {
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
    }

    private func bindTapAction() {
        rightTopButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.pushViewController(owner.factory.makeSettingViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setProperties() {
        navigationItem.setRightBarButton(UIBarButtonItem(customView: rightTopButton), animated: false)
    }

    private func setLayouts() {
        view.addSubviews(emptyLabel)
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(400)
            $0.centerX.equalToSuperview()
        }
    }
}

extension MyPageViewController: MyPageProfileDelegate {
    func profileViewDidTap() {
        guard let profile = reactor?.currentState.profile else { return }
        navigationController?.pushViewController(factory.makeMyInformationViewController(userProfile: profile), animated: true)
    }

    func historyButtonDidTap() {}

    func closetButtonDidTap() {
        let closet = factory.makeClosetMainViewController()
        navigationController?.pushViewController(closet, animated: true)
    }
}
