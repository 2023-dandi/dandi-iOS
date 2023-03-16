//
//  SectionTitleHeaderView.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/16.
//

import UIKit

import SnapKit
import YDS

final class SectionTitleHeaderView: UICollectionReusableView {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }

    func configure(text: String) {
        titleLabel.text = text
    }

    func render() {
        titleLabel.textColor = YDSColor.textPrimary
        titleLabel.font = YDSFont.title3
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
