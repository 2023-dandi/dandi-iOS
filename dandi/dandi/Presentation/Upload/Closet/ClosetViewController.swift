//
//  ClosetViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/15.
//

import UIKit

final class ClosetViewController: BaseViewController {
    private let closetView: ClosetView = .init()
    private lazy var datasource: ClosetDataSource = .init(collectionView: closetView.collectionView)

    override func loadView() {
        view = closetView
    }

    override init() {
        super.init()
        datasource.update(
            imageURLs: [
                ClosetImage(id: 1, imageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2"),
                ClosetImage(id: 2, imageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2"),
                ClosetImage(id: 3, imageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2"),
                ClosetImage(id: 4, imageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2"),
                ClosetImage(id: 5, imageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2")
            ])
    }

    func bind() {}
}
