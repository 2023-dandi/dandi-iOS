//
//  FeedViewController.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import UIKit

import RxCocoa
import RxSwift
import YDS

final class FeedViewController: BaseViewController {
    private let feedView: FeedView = .init()
    private lazy var feedDataSource: FeedDataSource = .init(
        collectionView: feedView.collectionView,
        presentingViewController: self
    )

    override func loadView() {
        view = feedView
    }

    override init() {
        super.init()
        bind()
        feedView.navigationTitleLabel.text = "\(UserDefaultHandler.shared.address)은 18도입니다.\n가디건을 걸치고 나가면 어떨까요?"
    }

    func bind() {
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

        NotificationCenterManager.reloadLocation.addObserver()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.feedView.navigationTitleLabel.text = "\(UserDefaultHandler.shared.address)은 18도입니다.\n가디건을 걸치고 나가면 어떨까요?"

            })
            .disposed(by: disposeBag)
    }
}
