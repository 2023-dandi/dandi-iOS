//
//  RootSwitcher.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/29.
//

import UIKit

final class RootSwitcher {
    enum Destination {
        case main
        case custom(UIViewController)
    }

    static func update(_ destination: Destination) {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        guard let delegate = sceneDelegate else {
            return
        }
        switch destination {
        case .main:
            delegate.window?.rootViewController = ModuleFactory.shared.makeTabBarViewController()
        // 테스트에만 사용할것
        case let .custom(viewController):
            delegate.window?.rootViewController = viewController
        }
    }
}
