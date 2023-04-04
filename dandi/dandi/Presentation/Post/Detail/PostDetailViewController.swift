//
//  PostDetailViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/10.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import YDS

final class PostDetailViewController: BaseViewController, View {
    typealias Reactor = PostDetailReactor

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
        collectionView: self.collectionView,
        presentingViewController: self
    )

    private let moreButton: UIButton = .init()
    private let commentBottomTextView: PostCommentTextView = .init()
    private var isKeyboardPresented = false

    private let likePublisher = PublishSubject<Int>()
    private let shouldReloadCommentsPublisher = PublishSubject<Void>()
    private let shouldDeleteCommentPublisher = PublishSubject<Int>()

    override init() {
        super.init()
        setLayout()
        setProperties()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    func bind(reactor: Reactor) {
        bindKeyboard()
        bindAction(reactor)
        bindState(reactor)
    }

    private func setProperties() {
        commentBottomTextView.configure(profileImageURL: nil)
        commentBottomTextView.innerTextView.delegate = self
        moreButton.setImage(YDSIcon.dotsVerticalLine.withRenderingMode(.alwaysTemplate), for: .normal)
        moreButton.tintColor = YDSColor.buttonNormal
        navigationItem.setRightBarButton(UIBarButtonItem(customView: moreButton), animated: false)
    }
}

extension PostDetailViewController {
    private func bindAction(_ reactor: Reactor) {
        rx.viewWillAppear.take(1).map { _ in }.share()
            .map { Reactor.Action.fetchPostDetail }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        shouldReloadCommentsPublisher
            .map { Reactor.Action.fetchComments }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        shouldDeleteCommentPublisher
            .map { Reactor.Action.deleteComment(commentID: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        likePublisher
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .map { _, _ in Reactor.Action.like }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        let moreButtonDidTap = moreButton.rx.tap
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Observable<PostDetailAlertType> in
                let actions: [PostDetailAlertType] = [.share, .delete]
                return owner.rx.makeActionSheet(
                    title: "게시물을 어떻게 하시겠어요?",
                    actions: actions,
                    closeAction: Alert(title: "닫기", style: .cancel)
                )
            }

        moreButtonDidTap.filter { $0 == .delete }
            .withUnretained(self)
            .map { _, _ in Reactor.Action.delete }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        commentBottomTextView.uploadButton.rx.tap
            .map { [weak self] _ -> String? in
                self?.commentBottomTextView.innerTextView.text
            }
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .map { Reactor.Action.postComment(content: $0) }
            .do { [weak self] _ in
                guard let self = self else { return }
                self.commentBottomTextView.innerTextView.text = ""
                self.commentBottomTextView.placeholderLabel.isHidden = false
                let lastSectionIndex = self.collectionView.numberOfSections - 1
                let lastItemIndex = self.collectionView.numberOfItems(inSection: lastSectionIndex) - 1
                if lastSectionIndex > 0, lastItemIndex > 0 {
                    let lastItemIndexPath = IndexPath(item: lastItemIndex, section: lastSectionIndex)
                    self.collectionView.scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
                }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindState(_ reactor: Reactor) {
        reactor.state
            .compactMap { $0.post }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, post in
                owner.dataSource.update(post: post, comments: [])
                owner.shouldReloadCommentsPublisher.onNext(())
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.comments }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, comments in
                owner.dataSource.reloadCommentSection(items: comments)
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.isLiked }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { _, _ in
                guard let postID = reactor.currentState.post?.id else { return }
                NotificationCenterManager.reloadPost.post(object: postID)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isDeleted }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, isDeleted in
                if isDeleted {
                    owner.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
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
                self.collectionView.snp.remakeConstraints {
                    $0.leading.top.trailing.equalTo(self.view.safeAreaLayoutGuide)
                    $0.bottom.equalTo(self.commentBottomTextView.snp.top)
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
                self.collectionView.snp.remakeConstraints {
                    $0.edges.equalToSuperview()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension PostDetailViewController: HeartButtonDelegate {
    func buttonDidTap(postID: Int) {
        likePublisher.onNext(postID)
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
                self.shouldDeleteCommentPublisher.onNext(item.id)
                completion(true)
            }
            deleteAction.image = YDSIcon.trashcanLine
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(YDSColor.buttonWarned)
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
