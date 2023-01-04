//
//  CardCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import UIKit

import SnapKit
import Then
import YDS

final class CardCollectionViewCell: UICollectionViewCell {
    private let mainImageView: UIImageView = .init()
    private let profileInfoView: ProfileInfoView = .init()
    private let contentLabel: YDSLabel = .init()
    private let commentButton: UIButton = .init()
    private let heartButton: UIButton = .init()
    private let buttonStackView: UIStackView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
        profileInfoView.nicknameLabel.text = nil
        profileInfoView.dateLabel.text = nil
        profileInfoView.profileImageView.image = nil
        heartButton.isSelected = false
    }

    public func configure(
        mainImageURL: String,
        profileImageURL: String,
        nickname: String,
        content: String,
        date: String,
        isLiked: Bool
    ) {
        mainImageView.image(url: mainImageURL)
        profileInfoView.profileImageView.image(url: profileImageURL)
        profileInfoView.nicknameLabel.text = nickname
        profileInfoView.dateLabel.text = date
        contentLabel.text = content
        heartButton.isSelected = isLiked
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardCollectionViewCell {
    private func setProperties() {
        contentView.do {
            $0.borderColor = YDSColor.borderThin
            $0.borderWidth = YDSConstant.Border.normal
            $0.cornerRadius = YDSConstant.Rounding.r4
        }
        mainImageView.do {
            $0.contentMode = .scaleAspectFill
        }
        contentLabel.do {
            $0.style = .caption0
            $0.textColor = YDSColor.textSecondary
        }
        buttonStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 4
            $0.distribution = .fill
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: .zero, left: 2, bottom: .zero, right: 2)
        }
        commentButton.do {
            $0.setImage(YDSIcon.commentLine.withTintColor(
                YDSColor.buttonNormal,
                renderingMode: .alwaysOriginal
            ), for: .normal)
        }
        // TODO: - 아이콘 교체
        heartButton.do {
            $0.setImage(YDSIcon.commentLine.withTintColor(
                YDSColor.buttonNormal,
                renderingMode: .alwaysOriginal
            ), for: .normal)
        }
    }

    private func setLayouts() {
        contentView.addSubviews(
            mainImageView,
            profileInfoView,
            contentLabel,
            buttonStackView
        )
        let spacer = UIView()
        spacer.isUserInteractionEnabled = false
        spacer.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        buttonStackView.addArrangedSubviews(spacer, heartButton, commentButton)
        mainImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(mainImageView.snp.width).multipliedBy(1.3)
        }
        profileInfoView.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileInfoView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(4)
        }
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(2)
            make.height.equalTo(28)
        }
        heartButton.snp.makeConstraints { make in
            make.size.equalTo(20).priority(.high)
        }
        commentButton.snp.makeConstraints { make in
            make.size.equalTo(20).priority(.high)
        }
    }
}

private final class ProfileInfoView: UIView {
    private(set) lazy var profileImageView: YDSProfileImageView = .init()
    private(set) lazy var nicknameLabel: YDSLabel = .init()
    private(set) lazy var dateLabel: YDSLabel = .init()
    private let contentStackView: UIStackView = .init()

    init() {
        super.init(frame: .zero)
        setProperties()
        setLayouts()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setProperties() {
        profileImageView.do {
            $0.size = .extraSmall
        }
        nicknameLabel.do {
            $0.style = .caption2
            $0.textColor = YDSColor.textPrimary
            $0.numberOfLines = 1
        }
        dateLabel.do {
            $0.style = .caption2
            $0.textColor = YDSColor.textTertiary
            $0.numberOfLines = 1
        }
        contentStackView.do {
            $0.axis = .vertical
        }
    }

    private func setLayouts() {
        addSubviews(profileImageView, contentStackView)
        contentStackView.addArrangedSubviews(nicknameLabel, dateLabel)
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
        }
        contentStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }
}
