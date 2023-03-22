//
//  PagerCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

import YDS

final class PagerCollectionViewCell: UICollectionViewCell {
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected
                ? YDSColor.bottomBarSelected
                : YDSColor.bottomBarNormal

            bottomLine.isHidden = !isSelected
        }
    }

    private let titleLabel = UILabel()
    private let bottomLine = UIView()

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
        titleLabel.font = YDSFont.button2
        titleLabel.textAlignment = .center
        isSelected = false
        bottomLine.backgroundColor = YDSColor.bottomBarSelected

        contentView.addSubviews(titleLabel, bottomLine)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        bottomLine.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
}
