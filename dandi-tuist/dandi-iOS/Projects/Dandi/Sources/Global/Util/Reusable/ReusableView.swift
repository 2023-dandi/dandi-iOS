//
//  ReusableView.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/16.
//

import UIKit.UIView

protocol ReusableView: AnyObject {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
