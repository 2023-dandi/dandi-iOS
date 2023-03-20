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
    private let locationTitleLabel = PaddingLabel()
    private let locationItem = YDSListItem(title: "서울특별시 상도동", showNextIconView: true)
    private let historyTitleLabel = PaddingLabel()
    private let closetItem = YDSListItem(title: "내 옷장", showNextIconView: true)
    private let likeItem = YDSListItem(title: "좋아요", showNextIconView: true)

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
                        owner.profileImageView.image = item.image
                    default:
                        break
                    }
                    library.dismiss(animated: true)
                }
                owner.present(library, animated: true)
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
        [locationTitleLabel, historyTitleLabel].forEach {
            $0.textColor = YDSColor.textSecondary
            $0.font = YDSFont.subtitle2
        }
        locationTitleLabel.text = "위치"
        historyTitleLabel.text = "내 기록"
    }

    private func setLayouts() {
        doneButton.snp.makeConstraints {
            $0.width.equalTo(48)
        }
        view.addSubviews(profileImageView, cameraIconView, textFieldView, contentStackView)
        contentStackView.addArrangedSubviews(
            locationTitleLabel,
            locationItem,
            historyTitleLabel,
            closetItem,
            likeItem
        )
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.centerX.equalToSuperview()
        }
        cameraIconView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.bottom.trailing.equalTo(profileImageView)
        }
        // TODO: - 레이아웃 에러 고치기
        textFieldView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(110)
        }
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(textFieldView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        locationTitleLabel.snp.makeConstraints {
            $0.height.equalTo(42).priority(.high)
        }
        historyTitleLabel.snp.makeConstraints {
            $0.height.equalTo(42).priority(.high)
        }
    }
}
