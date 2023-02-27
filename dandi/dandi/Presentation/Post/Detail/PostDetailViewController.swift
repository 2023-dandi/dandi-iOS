//
//  PostDetailViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/10.
//

import UIKit

import YDS

final class PostDetailViewController: BaseViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: createLayout())
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private lazy var dataSource = PostDetailDataSource(
        collectionView: self.collectionView
    )

    private let moreButton: UIButton = .init()
    private let textView: PostCommentTextView = .init()

    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    init(postID _: Int) {
        super.init()
        setLayout()
        setProperties()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.update(
            post: Post(
                id: 2,
                mainImageURL: "https://cdn.imweb.me/thumbnail/20211105/16246701edcd5.jpg",
                profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                nickname: "비오는 토요일",
                date: "22.11.09 11:00",
                content: "26도에 딱 적당해요!",
                isLiked: false
            ), comments: [
                Comment(
                    id: 0,
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "이지데이지",
                    date: "22.11.09 11:00",
                    content: "26도에 딱 적당해요!26도에 딱 적당해요!26도에 딱 적당해요!26도에 딱 적당해요!26도에 딱 적당해요!26도에 딱 적당해요!26도에 딱 적당해요!26도에 딱 적당해요!26도에 딱 적당해요!26도에 딱 적당해요!26도에 딱 적당해요!26도에 딱 적당해요!26도에 딱 적당해요!26도에 딱 적당해요!26도에 딱 적당해요!26도에 딱 적당해요!",
                    isMine: false
                ),
                Comment(
                    id: 1,
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "이지데이지",
                    date: "22.11.09 11:00",
                    content: "26도에 딱 적당해요!",
                    isMine: false
                ),
                Comment(
                    id: 2,
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "이지데이지",
                    date: "22.11.09 11:00",
                    content: "26도에 딱 적당해요!",
                    isMine: true
                ),
                Comment(
                    id: 3,
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "이지데이지",
                    date: "22.11.09 11:00",
                    content: "26도에 딱 적당해요!",
                    isMine: false
                )
            ]
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    private func setProperties() {
        moreButton.setImage(YDSIcon.dotsVerticalLine.withRenderingMode(.alwaysTemplate), for: .normal)
        moreButton.tintColor = YDSColor.buttonNormal
        navigationItem.setRightBarButton(UIBarButtonItem(customView: moreButton), animated: false)
    }

    private func setLayout() {
        view.addSubviews(collectionView, textView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        textView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.greaterThanOrEqualTo(53)
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = false

            config.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
                guard
                    let self = self,
                    let item = self.dataSource.commentItemIdentifier(for: indexPath),
                    item.isMine
                else {
                    let reportAction = UIContextualAction(
                        style: .normal,
                        title: nil
                    ) { _, _, completion in
                        // report 함수 구현
                        completion(true)
                    }
                    reportAction.image = YDSIcon.warningcircleLine
                    reportAction.backgroundColor = YDSColor.bgSelected
                    return UISwipeActionsConfiguration(actions: [reportAction])
                }
                let deleteAction = UIContextualAction(
                    style: .normal,
                    title: nil
                ) { _, _, completion in
                    // delete 함수 구현
                    completion(true)
                }
                deleteAction.image = YDSIcon.trashcanLine
                deleteAction.backgroundColor = YDSColor.buttonWarnedBG
                return UISwipeActionsConfiguration(actions: [deleteAction])
            }

            let section = NSCollectionLayoutSection.list(
                using: config,
                layoutEnvironment: layoutEnvironment
            )
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}
