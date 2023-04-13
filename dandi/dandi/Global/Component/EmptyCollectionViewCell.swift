//
//  EmptyCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/13.
//

import UIKit

import YDS

final class EmptyCollectionViewCell: UICollectionViewCell {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }

    func configure(text: String) {
        label.text = text
    }

    private func render() {
        label.numberOfLines = 0
        label.font = YDSFont.caption1
        label.textAlignment = .center
        label.textColor = YDSColor.textTertiary

        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
