//
//  ImageCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

import SnapKit
import YDS

final class ImageCollectionViewCell: UICollectionViewCell {
    enum CellType {
        case check
        case none
    }

    override var isSelected: Bool {
        didSet {
            let image = isSelected ? YDSIcon.checkcircleFilled : YDSIcon.checkcircleLine
            checkIconView.image = image
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(YDSColor.buttonPoint)
        }
    }

    override var contentMode: UIView.ContentMode {
        didSet {
            imageView.contentMode = contentMode
        }
    }

    var type: CellType = .none {
        didSet {
            checkIconView.isHidden = type != .check
        }
    }

    private let imageView: UIImageView = .init()
    private let checkIconView: UIImageView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayouts()
        setProperties()
    }

    func configure(image: UIImage) {
        imageView.image = image
    }

    func configure(imageURL: String) {
        imageView.image(url: imageURL)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageCollectionViewCell {
    private func setProperties() {
        checkIconView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        contentView.borderColor = YDSColor.borderNormal
        contentView.borderWidth = YDSConstant.Border.thin
    }

    private func setLayouts() {
        contentView.backgroundColor = YDSColor.bgRecomment
        contentView.addSubviews(imageView, checkIconView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        checkIconView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.right.equalToSuperview().inset(4)
        }
    }
}
