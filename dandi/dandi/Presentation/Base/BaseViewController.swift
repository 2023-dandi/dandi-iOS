//
//  BaseViewController.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import UIKit

class BaseViewController: UIViewController {
    public var factory: ModulFactoryInterface!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
