//
//  EmptyCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/13.
//

import UIKit

import YDS

final class EmptyCollectionViewCell: UICollectionViewCell {
    private let label = EmptyLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }

    func configure(text: String) {
        label.text = text
    }

    private func render() {
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

final class EmptyLabel: UILabel {
    convenience init(text: String) {
        self.init()
        self.text = text
    }

    init() {
        super.init(frame: .zero)
        self.numberOfLines = 0
        self.font = YDSFont.caption1
        self.textAlignment = .center
        self.textColor = YDSColor.textTertiary
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
