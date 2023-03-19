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
    }

    func bind() {
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
