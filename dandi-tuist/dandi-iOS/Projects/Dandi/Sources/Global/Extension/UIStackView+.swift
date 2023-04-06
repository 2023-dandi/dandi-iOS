//
//  UIStackView+.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/31.
//

import UIKit.UIStackView

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
