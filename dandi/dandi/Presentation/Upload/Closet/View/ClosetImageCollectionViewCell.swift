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
    override var isSelected: Bool {
        didSet {
            checkIconView.isHidden = !isSelected
            dimView.isHidden = !isSelected
        }
    }

    static let identifier = "ClosetImageCollectionViewCell"
    private let imageView: UIImageView = .init()
    private let checkIconView: UIImageView = .init()
    private let dimView: UIView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayouts()
        setProperties()
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
        dimView.backgroundColor = YDSColor.bgDimDark
        imageView.contentMode = .scaleAspectFit
        isSelected = false
    }

    private func setLayouts() {
        contentView.backgroundColor = YDSColor.bgRecomment
        contentView.addSubviews(imageView, dimView)
        dimView.addSubview(checkIconView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        checkIconView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.center.equalToSuperview()
        }
    }
}
