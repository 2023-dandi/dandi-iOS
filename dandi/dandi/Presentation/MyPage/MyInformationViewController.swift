//
//  MyInformationViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/27.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import YDS

final class MyInformationViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private let doneButton = UIButton()
    private let profileImageView = UIImageView()
    private let cameraIconView = UIImageView()

    private let contentStackView = UIStackView()
    private let textFieldView = YDSSimpleTextFieldView()
    private let locationTitleLabel = PaddingLabel()
    // TODO: - YDS 수정해야함
    private let locationItem = YDSListItem(title: "서울특별시 상도동", showNextIconView: true)
    private let historyTitleLabel = PaddingLabel()
    private let closetItem = YDSListItem(title: "내 옷장", showNextIconView: true)
    private let likeItem = YDSListItem(title: "좋아요", showNextIconView: true)

    override init() {
        super.init()
        setProperties()
        setLayouts()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    func bind() {
        profileImageView.rx.tapGesture
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let library = owner.factory.makePhotoLibraryViewController(maxNumberOfItems: 1)
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
                        dump(item.image)
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
            $0.cornerRadius = 60
            $0.backgroundColor = YDSColor.borderThin
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
            $0.size.equalTo(120)
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
            $0.height.equalTo(98)
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
