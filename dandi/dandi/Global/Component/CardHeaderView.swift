//
//  CardHeaderView.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/04.
//

import UIKit

import SnapKit
import Then
import YDS

final class CardHeaderView: UICollectionReusableView {
    private let contentStackView = UIStackView()
    private let titleLabel = YDSLabel(style: .title3)
    private let subtitleLabel = YDSLabel(style: .subtitle3)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    func configure(title: String, subtitle: String? = nil) {
        titleLabel.text = title
        guard let subtitle = subtitle else {
            subtitleLabel.isHidden = true
            return
        }
        subtitleLabel.text = subtitle
    }

    private func setProperties() {
        backgroundColor = YDSColor.bgNormal
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 2
        }
        subtitleLabel.do {
            $0.textColor = YDSColor.textSecondary
            $0.textAlignment = .left
        }
        titleLabel.do {
            $0.textColor = YDSColor.textSecondary
            $0.textAlignment = .left
        }
    }

    private func setLayouts() {
        addSubviews(contentStackView)
        contentStackView.addArrangedSubviews(titleLabel, subtitleLabel)
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
