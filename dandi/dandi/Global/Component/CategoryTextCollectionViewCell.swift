//
//  CategoryTextCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/26.
//

import UIKit

import YDS

final class CategoryTextCollectionViewCell: UICollectionViewCell {
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected
                ? YDSColor.bottomBarSelected
                : YDSColor.bottomBarNormal
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
        titleLabel.font = YDSFont.button3
        titleLabel.textAlignment = .center
        isSelected = false

        contentView.addSubviews(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }
}
