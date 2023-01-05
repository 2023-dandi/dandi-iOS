//
//  MainTabBarController.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import Foundation
import UIKit

import YDS

final class MainTabBarController: YDSBottomBarController {
    public let factory: ModulFactoryInterface

    init(factory: ModulFactoryInterface) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
    }
}

extension MainTabBarController {
    private func setViewControllers() {
        let homeVC = factory.makeHomeViewController()
        let homeNavigationController = YDSNavigationController(rootViewController: homeVC)
        homeNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: Tab.home.image,
            selectedImage: Tab.home.selectedImage
        )
        homeNavigationController.navigationBar.isHidden = true

        let feedVC = factory.makeFeedViewContontoller()
        let feedNavigationController = YDSNavigationController(rootViewController: feedVC)
        feedNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: Tab.feed.image,
            selectedImage: Tab.feed.selectedImage
        )
        feedNavigationController.navigationBar.isHidden = true

        let myPageVC = factory.makeMyPageViewController()
        let myPageNavigationController = YDSNavigationController(rootViewController: myPageVC)
        myPageNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: Tab.my.image,
            selectedImage: Tab.my.selectedImage
        )

        super.setViewControllers([
            homeNavigationController,
            feedNavigationController,
            myPageNavigationController
        ], animated: true)
    }
}
