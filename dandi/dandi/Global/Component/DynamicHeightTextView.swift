//
//  DynamicHeightTextView.swift
//  dandi
//
//  Created by 김윤서 on 2023/05/14.
//

import UIKit

class DynamicHeightTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }

    private let maxHeight: CGFloat = 119

    private var isOverHeight: Bool {
        return contentSize.height >= maxHeight
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        isScrollEnabled = isOverHeight

        if isScrollEnabled == false {
            invalidateIntrinsicContentSize()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
