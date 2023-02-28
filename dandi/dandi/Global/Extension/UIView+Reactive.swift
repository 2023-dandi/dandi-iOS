//
//  UIView+Reactive.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/28.
//

import UIKit.UIView

import RxSwift

public extension Reactive where Base: UIView {
    var tapGesture: Observable<Void> {
        return tapGesture { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        }
        .when(.recognized)
        .map { _ in }
    }
}
