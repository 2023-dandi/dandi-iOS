//
//  ModuleFactory.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import Foundation

protocol ModulFactoryInterface {
    func makeTabBarViewController() -> MainTabBarController
    func makeHomeViewController() -> HomeViewController
    func makeMyPageViewController() -> MyPageViewController
    func makeFeedViewContontoller() -> FeedViewController
    func makeClosetViewController() -> ClosetViewController
    func makePhotoLibraryViewController() -> PhotoLibraryViewController
}

final class ModuleFactory {
    static let shared = ModuleFactory()
    private init() {}
}

extension ModuleFactory: ModulFactoryInterface {
    func makeTabBarViewController() -> MainTabBarController {
        let vc = MainTabBarController(factory: self)
        return vc
    }

    func makeHomeViewController() -> HomeViewController {
        let vc = HomeViewController()
        vc.factory = self
        return vc
    }

    func makeMyPageViewController() -> MyPageViewController {
        let vc = MyPageViewController()
        vc.factory = self
        return vc
    }

    func makeFeedViewContontoller() -> FeedViewController {
        let vc = FeedViewController()
        vc.factory = self
        return vc
    }

    func makeClosetViewController() -> ClosetViewController {
        let vc = ClosetViewController()
        vc.factory = self
        return vc
    }

    func makePhotoLibraryViewController() -> PhotoLibraryViewController {
        let vc = PhotoLibraryViewController()
        vc.factory = self
        return vc
    }
}
