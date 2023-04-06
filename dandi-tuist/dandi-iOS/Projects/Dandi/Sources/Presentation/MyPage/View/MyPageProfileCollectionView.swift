//
//  MyPageProfileCollectionView.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/08.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then
import YDS

protocol MyPageProfileDelegate: AnyObject {
    func profileViewDidTap()
    func historyButtonDidTap()
    func closetButtonDidTap()
}

final class MyPageProfileCollectionViewCell: UICollectionViewCell {
    weak var delegate: MyPageProfileDelegate?

    private let disposeBag = DisposeBag()

    private let profileView: UIView = .init()
    private let profileImageView: YDSProfileImageView = .init()

    private let contentStackView: UIStackView = .init()
    private let nicknameLabel: UILabel = .init()
    private let closetLabel: UILabel = .init()
    private let locationLabel: UILabel = .init()
    private let arrowImageView: UIImageView = .init()

    private let buttonStackView: UIStackView = .init()
    private let historyButton: MyPageIconButton = .init()
    private let closetButton: MyPageIconButton = .init()

    private let separatorView: UIView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
        setTapGesture()
    }

    func configure(
        profileImageURL: String?,
        nickname: String,
        location: String,
        closetCount: Int
    ) {
        nicknameLabel.text = nickname
        locationLabel.text = location
        closetLabel.text = "\(closetCount)벌의 날씨 옷"
        profileImageView.image(url: profileImageURL, defaultImage: Image.defaultProfile)
    }

    // TODO: - Rx 제거
    private func setTapGesture() {
        closetButton.rx.tapGesture
            .bind(onNext: { [weak self] _ in
                self?.delegate?.closetButtonDidTap()
            })
            .disposed(by: disposeBag)
        historyButton.rx.tapGesture
            .bind(onNext: { [weak self] _ in
                self?.delegate?.historyButtonDidTap()
            })
            .disposed(by: disposeBag)
        profileView.rx.tapGesture
            .bind(onNext: { [weak self] _ in
                self?.delegate?.profileViewDidTap()
            })
            .disposed(by: disposeBag)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageProfileCollectionViewCell {
    private func setProperties() {
        profileImageView.do {
            $0.size = .large
        }
        nicknameLabel.do {
            $0.textColor = YDSColor.textPrimary
            $0.font = YDSFont.subtitle1
        }
        [closetLabel, locationLabel].forEach {
            $0.do {
                $0.textColor = YDSColor.textTertiary
                $0.font = YDSFont.caption0
            }
        }
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 2
        }
        arrowImageView.do {
            $0.image = YDSIcon.arrowRightLine
        }
        separatorView.do {
            $0.backgroundColor = YDSColor.borderNormal
        }
        buttonStackView.axis = .horizontal
        historyButton.configure(image: YDSIcon.heartLine, text: "좋아요 기록")
        closetButton.configure(image: YDSIcon.bellLine, text: "내 옷장")
    }

    private func setLayouts() {
        contentView.addSubviews(profileView, buttonStackView, separatorView)
        profileView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(108)
        }
        profileView.addSubviews(
            profileImageView,
            contentStackView,
            arrowImageView
        )
        contentStackView.addArrangedSubviews(
            nicknameLabel,
            closetLabel,
            locationLabel
        )
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        contentStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(40)
            make.centerY.equalToSuperview()
        }
        arrowImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
        buttonStackView.addArrangedSubviews(historyButton, UIView(), closetButton)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(72)
            make.bottom.equalTo(separatorView.snp.top).offset(-12)
        }
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(8)
            make.leading.bottom.trailing.equalToSuperview()
        }
        [historyButton, closetButton].forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(85)
            }
        }
    }
}

class MyPageIconButton: UIButton {
    private let contentStackView: UIStackView = .init()
    private let iconView: UIImageView = .init()
    private let label: UILabel = .init()

    init() {
        super.init(frame: .zero)
        render()
    }

    func configure(image: UIImage, text: String) {
        iconView.image = image
            .resize(newWidth: 24)
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(YDSColor.buttonNormal)
        label.text = text
    }

    private func render() {
        isUserInteractionEnabled = true
        iconView.contentMode = .scaleAspectFit

        label.font = YDSFont.button2
        label.textColor = YDSColor.buttonNormal
        label.textAlignment = .center

        contentStackView.spacing = 5
        contentStackView.contentMode = .center
        contentStackView.axis = .vertical
        contentStackView.distribution = .fillProportionally

        addSubview(contentStackView)
        contentStackView.addArrangedSubviews(iconView, label)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
