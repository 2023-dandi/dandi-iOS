//
//  PostCommentCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/27.
//

import UIKit

import SnapKit
import Then
import YDS

final class PostCommentCollectionViewCell: UICollectionViewCell {
    private let profileImageView: YDSProfileImageView = .init()
    private let contentStackView: UIStackView = .init()
    private let infoStackView: UIStackView = .init()
    private let nicknameLabel: UILabel = .init()
    private let contentLabel: UILabel = .init()
    private let dateLabel: UILabel = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nicknameLabel.text = nil
        contentLabel.text = nil
        dateLabel.text = nil
        nicknameLabel.textColor = YDSColor.textPrimary
    }

    func configure(
        profileImageURL: String?,
        nickname: String,
        content: String,
        date: String,
        isMine: Bool
    ) {
        profileImageView.image(url: profileImageURL, defaultImage: .add)
        nicknameLabel.text = nickname
        contentLabel.text = content
        dateLabel.text = date

        nicknameLabel.textColor = isMine
            ? YDSColor.textPointed
            : YDSColor.textPrimary
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostCommentCollectionViewCell {
    private func setProperties() {
        profileImageView.do {
            $0.size = .small
        }
        nicknameLabel.do {
            $0.font = YDSFont.body1
            $0.textColor = YDSColor.textPrimary
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }
        contentLabel.do {
            $0.font = YDSFont.body1
            $0.textColor = YDSColor.textSecondary
            $0.numberOfLines = 0
            $0.lineBreakMode = .byCharWrapping
        }
        dateLabel.do {
            $0.font = YDSFont.caption0
            $0.textColor = YDSColor.textTertiary
            $0.textAlignment = .right
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        infoStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
        }
        contentStackView.do {
            $0.axis = .vertical
        }
    }

    private func setLayouts() {
        infoStackView.addArrangedSubviews(nicknameLabel, dateLabel)
        contentStackView.addArrangedSubviews(infoStackView, contentLabel)
        contentView.addSubviews(
            profileImageView,
            contentStackView
        )
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        contentStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.top.bottom.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
