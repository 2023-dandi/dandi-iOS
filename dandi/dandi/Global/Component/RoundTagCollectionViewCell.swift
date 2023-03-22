//
//  RoundTagCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

import YDS

final class RoundTagCollectionViewCell: UICollectionViewCell {
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected
                ? YDSColor.buttonPoint
                : YDSColor.monoItemBG

            titleLabel.textColor = isSelected
                ? YDSColor.buttonBright
                : YDSColor.bottomBarNormal
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

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.cornerRadius = frame.height / 2
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func render() {
        titleLabel.font = YDSFont.button3
        titleLabel.textAlignment = .center
        isSelected = false

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.trailing.leading.equalToSuperview().inset(12)
        }
    }
}
