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
    public var isDisabled: Bool = false {
        didSet {
            contentView.backgroundColor = isDisabled
                ? YDSColor.buttonDisabledBG
                : YDSColor.buttonPointBG

            isUserInteractionEnabled = !isDisabled
        }
    }

    enum IconType {
        case add
        case camera

        var image: UIImage {
            switch self {
            case .add:
                return YDSIcon.plusLine
            case .camera:
                return YDSIcon.cameraFilled
            }
        }
    }

    private let addImageView: UIImageView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayouts()
    }

    func configure(type: IconType) {
        addImageView.image = type.image
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddButtonCollectionViewCell {
    private func setLayouts() {
        contentView.addSubview(addImageView)
        addImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(48)
        }
    }
}
