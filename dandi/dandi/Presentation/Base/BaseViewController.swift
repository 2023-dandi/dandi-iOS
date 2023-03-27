//
//  BaseViewController.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import UIKit

import RxSwift
import YDS

class BaseViewController: UIViewController {
    public var factory: ModuleFactoryInterface!
    public var disposeBag: DisposeBag = .init()

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = YDSColor.bgNormal
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
