//
//  NotificationCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/28.
//

import UIKit

import SnapKit
import Then
import YDS

final class NotificationCollectionViewCell: UICollectionViewCell {
    private let contentStackView = UIStackView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let newIcon = UIView()

    override init(frame _: CGRect) {
        super.init(frame: .zero)
        setProperties()
        setLayouts()
    }

    func configure(
        type: NotificationItemType,
        title: String,
        description: String?
    ) {
        iconView.image = type.image.withInset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        titleLabel.text = title
        guard let description = description else {
            descriptionLabel.isHidden = true
            return
        }
        descriptionLabel.text = description
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotificationCollectionViewCell {
    private func setProperties() {
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
        }
        titleLabel.do {
            $0.numberOfLines = 0
            $0.font = YDSFont.subtitle3
            $0.textColor = YDSColor.textPrimary
            $0.lineBreakMode = .byCharWrapping
        }
        descriptionLabel.do {
            $0.numberOfLines = 0
            $0.font = YDSFont.subtitle3
            $0.textColor = YDSColor.textTertiary
            $0.lineBreakMode = .byCharWrapping
        }
        iconView.do {
            $0.borderWidth = YDSConstant.Border.normal
            $0.borderColor = YDSColor.borderNormal
            $0.cornerRadius = 24
        }
        newIcon.do {
            $0.cornerRadius = 4
            $0.backgroundColor = YDSColor.pinkItemPrimary
        }
    }

    private func setLayouts() {
        contentView.addSubviews(iconView, contentStackView, newIcon)
        contentStackView.addArrangedSubviews(
            titleLabel,
            descriptionLabel
        )
        iconView.snp.makeConstraints {
            $0.size.equalTo(48)
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        contentStackView.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(16)
            $0.top.bottom.equalToSuperview().inset(12)
            $0.height.greaterThanOrEqualTo(40)
            $0.trailing.equalToSuperview().inset(16)
        }
        newIcon.snp.makeConstraints {
            $0.size.equalTo(8)
            $0.top.equalTo(contentStackView.snp.top)
            $0.trailing.equalTo(contentStackView.snp.trailing)
        }
    }
}
