//
//  PostContentCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/27.
//

import UIKit

import SnapKit
import Then
import YDS

final class PostContentCollectionViewCell: UICollectionViewCell {
    private let profileView: ProfileView = .init()
    private let mainImageView: UIImageView = .init()
    private let dateLabel: UILabel = .init()
    private let temperatureLabel: UILabel = .init()
    private let contentStackView: UIStackView = .init()
    private let heartButton: UIButton = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    func configure(post: Post) {
        profileView.configure(
            profileImageURL: post.profileImageURL,
            nickname: post.nickname,
            timestamp: post.date
        )
        mainImageView.image(url: post.mainImageURL)
        temperatureLabel.text = "\(post.content)"
        heartButton.isSelected = post.isLiked
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostContentCollectionViewCell {
    private func setProperties() {
        mainImageView.contentMode = .scaleAspectFill
        dateLabel.do {
            $0.textColor = YDSColor.textSecondary
            $0.font = YDSFont.subtitle2
        }
        temperatureLabel.do {
            $0.textColor = YDSColor.textSecondary
            $0.font = YDSFont.title3
        }
        contentStackView.do {
            $0.axis = .vertical
            $0.alignment = .leading
        }
        heartButton.do {
            $0.setImage(
                YDSIcon.heartFilled
                    .resize(newWidth: 32)
                    .withRenderingMode(.alwaysOriginal)
                    .withTintColor(YDSColor.buttonWarned),
                for: .selected
            )
            heartButton.do {
                $0.setImage(
                    YDSIcon.heartLine
                        .resize(newWidth: 32)
                        .withRenderingMode(.alwaysOriginal)
                        .withTintColor(YDSColor.buttonNormal),
                    for: .normal
                )
            }
        }
    }

    private func setLayouts() {
        contentStackView.addArrangedSubviews(temperatureLabel)
        contentView.addSubviews(
            profileView,
            mainImageView,
            contentStackView,
            heartButton
        )
        profileView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        mainImageView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width * 433 / 375 + 16)
        }
        contentStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(mainImageView.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(60)
            $0.bottom.equalToSuperview().offset(-12)
        }
        heartButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(contentStackView.snp.centerY)
        }
    }
}
