//
//  ClosetImageCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/19.
//

import UIKit

import SnapKit
import YDS

final class ClosetImageCollectionViewCell: UICollectionViewCell {
    enum CellType {
        case closet
        case home
    }

    override var isSelected: Bool {
        didSet {
            guard type == .closet else { return }
            checkIconView.isHidden = !isSelected
            backgroundColor = isSelected ?
                YDSColor.dimNormal : YDSColor.bgNormal
        }
    }

    var type: CellType = .closet

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

extension ClosetImageCollectionViewCell {
    private func setProperties() {
        checkIconView.image = YDSIcon.checkcircleFilled
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(YDSColor.buttonPoint)
        imageView.contentMode = .scaleAspectFit
        isSelected = false
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
