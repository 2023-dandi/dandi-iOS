//
//  ModuleFactory.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import Foundation

import YPImagePicker
protocol ModulFactoryInterface {
    func makeTabBarViewController() -> MainTabBarController
    func makeHomeViewController() -> HomeViewController
    func makeMyPageViewController() -> MyPageViewController
    func makeFeedViewContontoller() -> FeedViewController
    func makeClosetViewController() -> ClosetViewController
    func makePhotoLibraryViewController(maxNumberOfItems: Int) -> PhotoLibraryViewController
    func makePostDetailViewController(postID: Int) -> PostDetailViewController
    func makeMyInformationViewController() -> MyInformationViewController
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

    func makePhotoLibraryViewController(maxNumberOfItems: Int) -> PhotoLibraryViewController {
        let vc = PhotoLibraryViewController(maxNumberOfItems: maxNumberOfItems)
        return vc
    }

    func makePostDetailViewController(postID: Int) -> PostDetailViewController {
        let vc = PostDetailViewController(postID: postID)
        vc.factory = self
        return vc
    }

    func makeMyInformationViewController() -> MyInformationViewController {
        let vc = MyInformationViewController()
        vc.factory = self
        return vc
    }
}
