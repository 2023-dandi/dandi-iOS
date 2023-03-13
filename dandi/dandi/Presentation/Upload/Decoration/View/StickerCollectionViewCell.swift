//
//  StickerCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/13.
//

import UIKit

import SnapKit
import YDS

final class StickerCollectionViewCell: UICollectionViewCell {
    static let identifier = "StickerCollectionViewCell"
    private let imageView: UIImageView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayouts()
        setProperties()
        configure(image: .add)
    }

    func configure(image: UIImage) {
        imageView.image = image
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StickerCollectionViewCell {
    private func setProperties() {
        imageView.contentMode = .scaleAspectFill
    }

    private func setLayouts() {
        contentView.backgroundColor = YDSColor.bgRecomment
        contentView.addSubviews(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
