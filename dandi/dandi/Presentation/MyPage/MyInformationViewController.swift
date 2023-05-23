//
//  MyInformationViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/27.
//

import UIKit

import ReactorKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import YDS

final class MyInformationViewController: BaseViewController, View {
    typealias Reactor = MyInformationReactor

    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private let doneButton = UIButton()
    private let profileImageView = YDSProfileImageView()
    private let cameraIconView = UIImageView()

    private let contentStackView = UIStackView()
    private let textFieldView = YDSSimpleTextFieldView()

    private let locationTitleLabel = UILabel()
    private let locationItem = ListItem()

    private let likeHistoryTitleLabel = UILabel()
    private let likeHistoryItem = ListItem()

    private var isNicknameChanged: Bool = false
    private var isProfileChanged: Bool = false

    override init() {
        super.init()
        setProperties()
        setLayouts()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    func bind(reactor: Reactor) {
        bindTapAction()
        bindAction(reactor)
        bindState(reactor)
    }

    private func bindState(_ reactor: Reactor) {
        reactor.state
            .compactMap { $0.isValidNickname }
            .subscribe(onNext: { [weak self] isValid in
                self?.doneButton.isEnabled = isValid
                self?.textFieldView.isPositive = isValid
                self?.textFieldView.isNegative = !isValid
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.helperText }
            .subscribe(onNext: { [weak self] text in
                self?.textFieldView.helperLabelText = text
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.isUpdateCompleted }
            .subscribe(onNext: { [weak self] isUpdateCompleted in
                if isUpdateCompleted {
                    NotificationCenterManager.reloadProfile.post()
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindAction(_ reactor: Reactor) {
        rx.viewWillAppear
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.textFieldView.text = reactor.currentState.profile.nickname
                self?.profileImageView.image(url: reactor.currentState.profile.profileImageURL)
            })
            .disposed(by: disposeBag)

        textFieldView.textField.rx.text
            .do { [weak self] _ in
                self?.textFieldView.isPositive = false
                self?.textFieldView.isNegative = false
                self?.textFieldView.helperLabelText = " "
                self?.isNicknameChanged = true
            }
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .compactMap { $0 }
            .map { Reactor.Action.checkNicknameValidation(nickname: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        doneButton.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                Reactor.Action.update(
                    nickname: owner.isNicknameChanged ? owner.textFieldView.text : nil,
                    image: owner.isProfileChanged ? owner.profileImageView.image : nil
                )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        locationItem.rx.tapGesture
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let vc = owner.factory.makeLocationSettingViewController(from: .default)
                owner.present(YDSNavigationController(rootViewController: vc), animated: true)
            })
            .disposed(by: disposeBag)

        likeHistoryItem.rx.tapGesture
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let vc = owner.factory.makeLikedHistoryViewController()
                owner.present(YDSNavigationController(rootViewController: vc), animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func bindTapAction() {
        profileImageView.rx.tapGesture
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let library = owner.factory.makePhotoLibraryViewController()
                library.modalPresentationStyle = .fullScreen
                library.didFinishPicking { [unowned library] items, cancelled in
                    guard
                        !cancelled,
                        let firstItem = items.first
                    else {
                        library.dismiss(animated: true, completion: nil)
                        return
                    }

                    switch firstItem {
                    case let .photo(item):
                        owner.isProfileChanged = true
                        owner.doneButton.isEnabled = true
                        owner.profileImageView.image = item.image
                    default:
                        break
                    }
                    library.dismiss(animated: true)
                }
                owner.present(library, animated: true)
            })
            .disposed(by: disposeBag)

        NotificationCenterManager.reloadLocation.addObserver()
            .subscribe(onNext: { [weak self] _ in
                self?.locationItem.text = UserDefaultHandler.shared.address
            })
            .disposed(by: disposeBag)
    }

    private func setProperties() {
        navigationItem.setRightBarButton(UIBarButtonItem(customView: doneButton), animated: false)
        title = "내 정보"
        doneButton.do {
            $0.isEnabled = false
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(YDSColor.textDisabled, for: .disabled)
            $0.setTitleColor(YDSColor.buttonNormal, for: .normal)
            $0.titleLabel?.font = YDSFont.subtitle2
        }
        profileImageView.do {
            $0.size = .extraLarge
        }
        cameraIconView.do {
            $0.image = YDSIcon.cameraLine
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(YDSColor.buttonBright)
                .withInset(UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))

            $0.backgroundColor = YDSColor.buttonPoint
            $0.cornerRadius = 20
        }
        contentStackView.do {
            $0.axis = .vertical
        }
        textFieldView.do {
            $0.fieldLabelText = "닉네임"
            $0.helperLabelText = " "
        }
        locationTitleLabel.do {
            $0.textColor = YDSColor.textSecondary
            $0.font = YDSFont.subtitle3
            $0.text = "위치"
        }
        locationItem.text = UserDefaultHandler.shared.address
        likeHistoryTitleLabel.do {
            $0.textColor = YDSColor.textSecondary
            $0.font = YDSFont.subtitle3
            $0.text = "기록"
        }
        likeHistoryItem.text = "좋아요 기록"
    }

    private func setLayouts() {
        doneButton.snp.makeConstraints {
            $0.width.equalTo(48)
        }
        view.addSubviews(profileImageView, cameraIconView, textFieldView, contentStackView)
        contentStackView.addArrangedSubviews(
            locationTitleLabel,
            locationItem,
            likeHistoryTitleLabel,
            likeHistoryItem
        )
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.centerX.equalToSuperview()
        }
        cameraIconView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.bottom.trailing.equalTo(profileImageView)
        }
        textFieldView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(110)
        }
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(textFieldView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        locationTitleLabel.snp.makeConstraints {
            $0.height.equalTo(42).priority(.high)
        }
        locationItem.snp.makeConstraints {
            $0.height.equalTo(48).priority(.high)
        }
        likeHistoryTitleLabel.snp.makeConstraints {
            $0.height.equalTo(42).priority(.high)
        }
        likeHistoryItem.snp.makeConstraints {
            $0.height.equalTo(48).priority(.high)
        }
    }
}

private class ListItem: UIView {
    var text: String? {
        didSet {
            guard let text = text else { return }
            titleLabel.text = text
        }
    }

    private let titleLabel: YDSLabel = {
        let label = YDSLabel(style: .body1)
        label.textColor = YDSColor.textSecondary
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let nextIconView: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = YDSColor.buttonNormal
        icon.image = YDSIcon.arrowRightLine
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(YDSColor.buttonNormal)
        return icon
    }()

    init() {
        super.init(frame: .zero)
        render()
    }

    private func render() {
        addSubview(titleLabel)
        addSubview(nextIconView)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(nextIconView.snp.leading)
        }
        nextIconView.snp.makeConstraints {
            $0.size.equalTo(24).priority(.high)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
