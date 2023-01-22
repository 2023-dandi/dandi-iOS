//
//  ImageCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/19.
//

import UIKit

import SnapKit
import YDS

final class ImageCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    func configure(imageURL: String) {
        imageView.image(url: imageURL)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageCollectionViewCell {
    private func setProperties() {
        contentView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFit
    }

    private func setLayouts() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
