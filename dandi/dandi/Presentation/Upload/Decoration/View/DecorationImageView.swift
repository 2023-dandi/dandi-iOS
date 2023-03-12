//
//  DecorationImageView.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/12.
//

import UIKit

import SnapKit
import Then
import YDS

final class ImageGestureView: UIView {
    override var intrinsicContentSize: CGSize {
        if let myImage = imageView.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = frame.size.width

            let ratio = myViewWidth / myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth + 12, height: scaledHeight + 12)
        }
        return CGSize(width: -1.0, height: -1.0)
    }

    private(set) lazy var imageView = UIImageView()
    private(set) lazy var deleteButton = UIButton()
    private(set) lazy var zoomIcon = UIImageView()

    init() {
        super.init(frame: .zero)
        setLayouts()
        setProperties()
        isUserInteractionEnabled = true
        zoomIcon.isUserInteractionEnabled = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setProperties() {
        imageView.contentMode = .scaleAspectFit
        imageView.borderColor = .brown
        imageView.borderWidth = YDSConstant.Border.normal
        deleteButton.setImage(.remove, for: .normal)
        zoomIcon.image = .actions
    }

    private func setLayouts() {
        addSubviews(imageView, deleteButton, zoomIcon)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(24)
        }
        zoomIcon.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
}
