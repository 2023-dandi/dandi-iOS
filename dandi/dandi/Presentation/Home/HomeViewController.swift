//
//  HomeViewController.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import UIKit

final class HomeViewController: BaseViewController {
    private let homeView: HomeView = .init()
    private lazy var homeDataSource: HomeDataSource = .init(
        collectionView: homeView.collectionView,
        presentingViewController: self
    )

    override func loadView() {
        view = homeView
    }

    override init() {
        super.init()
        homeDataSource.update(
            same: [
                Post(
                    id: 1,
                    mainImageURL: "https://cdn.imweb.me/thumbnail/20211105/16246701edcd5.jpg",
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "비오는 토요일",
                    date: "22.11.09 11:00",
                    content: "26도에 딱 적당해요!",
                    isLiked: false
                ),
                Post(
                    id: 2,
                    mainImageURL: "https://cdn.imweb.me/thumbnail/20211105/16246701edcd5.jpg",
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "비오는 토요일",
                    date: "22.11.09 11:00",
                    content: "26도에 딱 적당해요!",
                    isLiked: false
                ),
                Post(
                    id: 3,
                    mainImageURL: "https://cdn.imweb.me/thumbnail/20211105/16246701edcd5.jpg",
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "비오는 토요일",
                    date: "22.11.09 11:00",
                    content: "26도에 딱 적당해요!",
                    isLiked: false
                )
            ], recommendation: [
                Post(
                    id: 1,
                    mainImageURL: "https://cdn.imweb.me/thumbnail/20211105/16246701edcd5.jpg",
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "비오는 토요일",
                    date: "22.11.09 11:00",
                    content: "26도에 딱 적당해요!",
                    isLiked: false
                ),
                Post(
                    id: 2,
                    mainImageURL: "https://cdn.imweb.me/thumbnail/20211105/16246701edcd5.jpg",
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "비오는 토요일",
                    date: "22.11.09 11:00",
                    content: "26도에 딱 적당해요!",
                    isLiked: false
                ),
                Post(
                    id: 3,
                    mainImageURL: "https://cdn.imweb.me/thumbnail/20211105/16246701edcd5.jpg",
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "비오는 토요일",
                    date: "22.11.09 11:00",
                    content: "26도에 딱 적당해요!",
                    isLiked: false
                )
            ]
        )
    }
}
