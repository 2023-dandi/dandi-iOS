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

    override init(frame _: CGRect) {
        super.init(frame: .zero)
        setProperties()
        setLayouts()
    }

    func configure(
        type: NotificationType,
        title: String,
        description: String?,
        isHighlighted: Bool = false
    ) {
        iconView.image = type.image
        titleLabel.text = title
        contentView.backgroundColor = isHighlighted ? YDSColor.buttonPointBG : YDSColor.bgNormal
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
    }

    private func setLayouts() {
        contentView.addSubviews(iconView, contentStackView)
        contentStackView.addArrangedSubviews(titleLabel, descriptionLabel)
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
    }
}