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
    private let heartButton: UIButton = .init()
    private let contentStackView: UIStackView = .init()

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
        profileImageURL: String?,
        nickname: String,
        content: String,
        date: String,
        isLiked: Bool
    ) {
        mainImageView.image(url: mainImageURL)
        profileInfoView.profileImageView.image(
            url: profileImageURL,
            defaultImage: Image.defaultProfile
        )
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
        contentStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = 4
            $0.distribution = .fill
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: .zero, left: 2, bottom: .zero, right: 2)
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
            contentStackView
        )
        contentStackView.addArrangedSubviews(contentLabel, heartButton)
        mainImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(mainImageView.snp.width).multipliedBy(1.3)
        }
        profileInfoView.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(48)
        }
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(profileInfoView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(28).priority(.high)
        }
        heartButton.snp.makeConstraints { make in
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
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        contentStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
    }
}
