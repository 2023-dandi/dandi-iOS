//
//  TagCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/16.
//

import UIKit

import YDS

final class TagCollectionViewCell: UICollectionViewCell {
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected
                ? YDSColor.buttonPoint
                : YDSColor.monoItemBG

            titleLabel.textColor = isSelected
                ? YDSColor.buttonBright
                : YDSColor.monoItemText
        }
    }

    override var isUserInteractionEnabled: Bool {
        didSet {
            if isUserInteractionEnabled {
                contentView.backgroundColor = YDSColor.buttonBright
                titleLabel.textColor = YDSColor.monoItemText
                borderColor = YDSColor.borderNormal
            }
        }
    }

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }

    func configure(text: String) {
        titleLabel.text = text
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func render() {
        contentView.cornerRadius = YDSConstant.Rounding.r4
        titleLabel.font = YDSFont.button0
        isSelected = false

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }
}
