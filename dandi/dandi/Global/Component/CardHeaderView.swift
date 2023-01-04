//
//  CardHeaderView.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/04.
//

import UIKit

import SnapKit
import YDS

final class CardHeaderView: UICollectionReusableView {
    private let titleLabel = YDSLabel(style: .title3)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    func configure(title: String) {
        titleLabel.text = title
    }

    private func setProperties() {
        titleLabel.textColor = YDSColor.textSecondary
        titleLabel.textAlignment = .left
        backgroundColor = YDSColor.bgNormal
    }

    private func setLayouts() {
        addSubviews(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
