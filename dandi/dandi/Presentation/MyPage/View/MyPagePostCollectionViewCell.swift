//
//  MyPagePostCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/28.
//

import UIKit

import SnapKit
import YDS

final class MyPagePostCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }

    func configure(imageURL: String) {
        imageView.image(url: imageURL)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPagePostCollectionViewCell {
    private func render() {
        contentView.backgroundColor = .cyan
        imageView.contentMode = .scaleAspectFill

        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
