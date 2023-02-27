//
//  MyPageViewController.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import UIKit

import RxCocoa
import RxSwift

final class MyPageViewController: BaseViewController {
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
        bind()
        myPageDataSource.update(
            user: UserProfile(
                profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                nickname: "ezidayzi",
                location: "서울시 동작구",
                closetCount: 10
            ),
            feed: [
                Post(
                    id: 1,
                    mainImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "김윤서",
                    date: "2000.11.26",
                    content: "아으 추워요!!",
                    isLiked: true
                ),
                Post(
                    id: 2,
                    mainImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "김윤서",
                    date: "2000.11.26",
                    content: "아으 추워요!!",
                    isLiked: true
                ),
                Post(
                    id: 3,
                    mainImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "김윤서",
                    date: "2000.11.26",
                    content: "아으 추워요!!",
                    isLiked: true
                ),
                Post(
                    id: 4,
                    mainImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "김윤서",
                    date: "2000.11.26",
                    content: "아으 추워요!!",
                    isLiked: true
                ),
                Post(
                    id: 5,
                    mainImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "김윤서",
                    date: "2000.11.26",
                    content: "아으 추워요!!",
                    isLiked: true
                ),
                Post(
                    id: 6,
                    mainImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "김윤서",
                    date: "2000.11.26",
                    content: "아으 추워요!!",
                    isLiked: true
                )
            ]
        )
    }

    func bind() {
        myPageView.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                switch owner.myPageDataSource.itemIdentifier(for: indexPath) {
                case .profile:
                    owner.navigationController?.pushViewController(
                        MyInformationViewController(),
                        animated: true
                    )
                case let .post(post):
                    owner.navigationController?.pushViewController(
                        PostDetailViewController(postID: post.id),
                        animated: true
                    )
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
