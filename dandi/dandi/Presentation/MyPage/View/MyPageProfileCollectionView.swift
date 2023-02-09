//
//  MyPageProfileCollectionView.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/08.
//

import UIKit

import SnapKit
import Then
import YDS

final class MyPageProfileCollectionViewCell: UICollectionViewCell {
    private let profileImageView: UIImageView = .init()
    private let contentStackView: UIStackView = .init()
    private let nicknameLabel: UILabel = .init()
    private let closetLabel: UILabel = .init()
    private let locationLabel: UILabel = .init()
    private let arrowImageView: UIImageView = .init()
    private let separatorView: UIView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
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

        guard let profileImageURL = profileImageURL else { return }
        profileImageView.image(url: profileImageURL)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageProfileCollectionViewCell {
    private func setProperties() {
        profileImageView.do {
            $0.cornerRadius = 38
            $0.contentMode = .scaleAspectFill
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
    }

    private func setLayouts() {
        contentView.addSubviews(
            profileImageView,
            contentStackView,
            arrowImageView,
            separatorView
        )
        contentStackView.addArrangedSubviews(
            nicknameLabel,
            closetLabel,
            locationLabel
        )
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(76)
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
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(8)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
}
