//
//  PostDetailViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/10.
//

import UIKit

import YDS

final class PostDetailViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: createLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var dataSource = PostDetailDataSource(
        collectionView: self.collectionView
    )

    private let moreButton: UIButton = .init()
    private let commentBottomTextView: PostCommentTextView = .init()
    private var isKeyboardPresented = false

    init(postID _: Int) {
        super.init()
        setLayout()
        setProperties()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        dataSource.update(
            post: Post(
                id: 2,
                mainImageURL: "https://cdn.imweb.me/thumbnail/20211105/16246701edcd5.jpg",
                profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                nickname: "비오는 토요일",
                date: "22.11.09 11:00",
                content: "26도에 딱 적당해요!",
                isLiked: false
            ),
            tag: WeatherFeeling.allCases,
            comments: [
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

    private func bind() {
        bindKeyboard()
    }

    private func setProperties() {
        commentBottomTextView.configure(profileImageURL: nil)
        commentBottomTextView.innerTextView.delegate = self
        moreButton.setImage(YDSIcon.dotsVerticalLine.withRenderingMode(.alwaysTemplate), for: .normal)
        moreButton.tintColor = YDSColor.buttonNormal
        navigationItem.setRightBarButton(UIBarButtonItem(customView: moreButton), animated: false)
    }

    private func bindKeyboard() {
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo }
            .map { userInfo -> CGFloat in
                (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            }
            .subscribe(onNext: { [weak self] height in
                guard let self = self else { return }
                self.isKeyboardPresented = true
                self.commentBottomTextView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-height)
                }
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .compactMap { $0.userInfo }
            .map { userInfo -> CGFloat in
                (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isKeyboardPresented = false
                self.commentBottomTextView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-12)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension PostDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        commentBottomTextView.placeholderLabel.isHidden = !textView.text.isEmpty
        commentBottomTextView.uploadButton.isEnabled = !textView.text.isEmpty
    }
}

// MARK: - UICollectionViewDelegate

extension PostDetailViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isKeyboardPresented == false else { return }
        let scrollViewTranslationY = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let offsetY = scrollViewTranslationY < 0 ? 90 : -12
        view.layoutSubviews()
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            self.commentBottomTextView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(offsetY)
            }
            if scrollViewTranslationY < 0 {
                self.collectionView.snp.remakeConstraints {
                    $0.edges.equalToSuperview()
                }
            } else {
                self.collectionView.snp.remakeConstraints {
                    $0.edges.equalTo(self.view.safeAreaLayoutGuide)
                }
            }
            self.view.layoutSubviews()
        }
    }
}

// MARK: - Layout

extension PostDetailViewController {
    private func setLayout() {
        view.addSubviews(collectionView, commentBottomTextView)
        collectionView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        commentBottomTextView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-12)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.greaterThanOrEqualTo(53)
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 1:
                return self?.createVerticalTagSection()
            default:
                return self?.createListSection(layoutEnvironment: layoutEnvironment)
            }
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }

    private func createListSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
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
                reportAction.backgroundColor = YDSColor.bgRecomment
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

    private func createVerticalTagSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .absolute(30)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(30)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(4)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 0, leading: 20, bottom: 16, trailing: 20)

        return section
    }
}
