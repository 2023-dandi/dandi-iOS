//
//  StickerEditorViewControl.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/13.
//

import UIKit

final class StickerEditorViewControl: UIImageView {
    init(image: UIImage?, gestureRecognizer: UIGestureRecognizer) {
        super.init(image: image)

        addGestureRecognizer(gestureRecognizer)
        self.frame = CGRect(
            x: 0,
            y: 0,
            width: 24,
            height: 24
        )

        layer.cornerRadius = frame.width / 2
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
