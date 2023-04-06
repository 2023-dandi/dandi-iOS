//
//  DecorationImageView.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/13.
//

import UIKit

import SnapKit
import Then
import YDS

final class DecorationImageView: UIImageView {
    init() {
        super.init(frame: .zero)
    }

    func makeImage() -> UIImage? {
        let rect = bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        drawHierarchy(in: rect, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    private func setProperties() {
        clipsToBounds = true
        contentMode = .scaleToFill
        backgroundColor = YDSColor.bgDimDark
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
