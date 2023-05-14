//
//  PaddingLabel.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/27.
//

import UIKit

class PaddingLabel: UILabel {
    private var padding: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    convenience init(padding: UIEdgeInsets) {
        self.init(frame: .zero)
        self.padding = padding
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += padding.left + padding.right
        contentSize.height += padding.top + padding.bottom
        return contentSize
    }

    override func drawText(in rect: CGRect) {
        let paddedRect = rect.inset(by: padding)
        super.drawText(in: paddedRect)
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let paddedBounds = bounds.inset(by: padding)
        let textRect = super.textRect(forBounds: paddedBounds, limitedToNumberOfLines: numberOfLines)
        let unpaddedRect = textRect.insetBy(dx: -padding.left, dy: -padding.top)
        return unpaddedRect
    }
}
