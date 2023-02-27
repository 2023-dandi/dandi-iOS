//
//  UIView+.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import UIKit.UIView

extension UIView {
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }

    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }

    func addGradient(
        colors: [UIColor],
        startPoint: CGPoint? = CGPoint(x: 0.5, y: 0.0),
        endPoint: CGPoint? = CGPoint(x: 0.5, y: 1.0)
    ) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint ?? CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = endPoint ?? CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
