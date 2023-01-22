//
//  AddButtonCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/19.
//

import UIKit

import SnapKit
import YDS

final class AddButtonCollectionViewCell: UICollectionViewCell {
    private let addImageView: UIImageView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddButtonCollectionViewCell {
    private func setProperties() {
        addImageView.image = YDSIcon.plusLine
    }

    private func setLayouts() {
        contentView.addSubview(addImageView)
        addImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(48)
        }
    }
}
