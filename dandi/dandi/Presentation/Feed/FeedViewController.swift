//
//  FeedViewController.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import UIKit

import RxCocoa
import RxSwift

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
        feedView.navigationTitleLabel.text = "현재 상도동은 18도입니다.\n가디건을 걸치고 나가면 어떨까요?"
        feedDataSource.update(feed: [
            Post(
                id: 1,
                mainImageURL: "https://cdn.imweb.me/thumbnail/20211105/16246701edcd5.jpg",
                profileImageURL: "",
                nickname: "비오는 토요일",
                date: "22.11.09 11:00",
                content: "26도에 딱 적당해요!",
                isLiked: false
            ),
            Post(
                id: 2,
                mainImageURL: "https://cdn.imweb.me/thumbnail/20211105/16246701edcd5.jpg",
                profileImageURL: "",
                nickname: "비오는 토요일",
                date: "22.11.09 11:00",
                content: "26도에 딱 적당해요!",
                isLiked: false
            ),
            Post(
                id: 3,
                mainImageURL: "https://cdn.imweb.me/thumbnail/20211105/16246701edcd5.jpg",
                profileImageURL: "",
                nickname: "비오는 토요일",
                date: "22.11.09 11:00",
                content: "26도에 딱 적당해요!",
                isLiked: false
            )
        ])
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
    }
}
