//
//  ProfileView.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/27.
//

import UIKit

import Then
import YDS

final class ProfileView: UIView {
    private let contentView: UIStackView = .init()
    private let imageView: YDSProfileImageView = .init()
    private let nicknameLabel: UILabel = .init()
    private let timestampLabel: UILabel = .init()

    init() {
        super.init(frame: .zero)
        setProperties()
        setLayouts()
    }

    func configure(
        profileImageURL: String?,
        nickname: String,
        timestamp: String
    ) {
        imageView.image(url: profileImageURL, defaultImage: .add)
        nicknameLabel.text = nickname
        timestampLabel.text = timestamp
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setProperties() {
        contentView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        imageView.do {
            $0.size = .medium
        }
        nicknameLabel.do {
            $0.font = YDSFont.subtitle3
            $0.textColor = YDSColor.textPrimary
        }
        timestampLabel.do {
            $0.font = YDSFont.caption2
            $0.textColor = YDSColor.textTertiary
        }
    }

    private func setLayouts() {
        let spacer = UIView()

        addSubview(contentView)
        contentView.addArrangedSubviews(
            imageView,
            nicknameLabel,
            spacer,
            timestampLabel
        )
        contentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
    }
}
