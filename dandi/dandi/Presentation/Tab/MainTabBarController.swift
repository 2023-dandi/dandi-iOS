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
    public let factory: ModuleFactoryInterface

    init(factory: ModuleFactoryInterface) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseService.shared.requestNotification()
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
        feedNavigationController.title = "둘러보기"
        feedNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: Tab.feed.image,
            selectedImage: Tab.feed.selectedImage
        )

        let chatVC = factory.makeChatViewController()
        let chatNavigationController = YDSNavigationController(rootViewController: chatVC)
        chatNavigationController.title = "단디챗"
        chatNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: Tab.chat.image,
            selectedImage: Tab.chat.selectedImage
        )

        let closetVC = factory.makeClosetMainViewController()
        let closetNavigationController = YDSNavigationController(rootViewController: closetVC)
        closetNavigationController.title = "내 옷장"
        closetNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: Tab.closet.image,
            selectedImage: Tab.closet.selectedImage
        )

        let myPageVC = factory.makeMyPageViewController()
        let myPageNavigationController = YDSNavigationController(rootViewController: myPageVC)
        myPageNavigationController.title = "마이페이지"
        myPageNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: Tab.my.image,
            selectedImage: Tab.my.selectedImage
        )

        super.setViewControllers([
            homeNavigationController,
            closetNavigationController,
            feedNavigationController,
            chatNavigationController,
            myPageNavigationController
        ], animated: true)
    }
}
