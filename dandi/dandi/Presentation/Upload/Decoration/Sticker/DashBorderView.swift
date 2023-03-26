//
//  DashBorderView.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/13.
//

import UIKit

final class BorderView: UIView {
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            context.saveGState()
            context.setLineWidth(1)

            let dash: [CGFloat] = [4.0, 2.0]
            context.setLineDash(phase: 0.0, lengths: dash)

            UIColor.white.setStroke()

            context.addRect(rect)
            context.strokePath()

            context.restoreGState()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
    }
}
