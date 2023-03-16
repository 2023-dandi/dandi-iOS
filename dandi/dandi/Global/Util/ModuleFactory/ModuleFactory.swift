//
//  ModuleFactory.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import Foundation
import UIKit

import YPImagePicker

protocol ModulFactoryInterface {
    func makeSplahViewController() -> SplashViewController
    func makeTabBarViewController() -> MainTabBarController
    func makeLoginViewController() -> LoginViewController
    func makeHomeViewController() -> HomeViewController
    func makeMyPageViewController() -> MyPageViewController
    func makeFeedViewContontoller() -> FeedViewController
    func makeClosetViewController() -> ClosetViewController
    func makePhotoLibraryViewController() -> PhotoLibraryViewController
    func makePostDetailViewController(postID: Int) -> PostDetailViewController
    func makeMyInformationViewController() -> MyInformationViewController
    func makeDecorationViewController(selectedImages: [UIImage]) -> DecorationViewController
}

final class ModuleFactory {
    static let shared = ModuleFactory()
    private init() {}
}

extension ModuleFactory: ModulFactoryInterface {
    func makeSplahViewController() -> SplashViewController {
        let vc = SplashViewController()
        return vc
    }
    
    func makeTabBarViewController() -> MainTabBarController {
        let vc = MainTabBarController(factory: self)
        return vc
    }

    func makeLoginViewController() -> LoginViewController {
        let vc = LoginViewController()
        vc.reactor = LoginReactor(
            authUseCase: DefaultAuthUseCase(
                authRepository: DefaultAuthRepository(
                    interceptor: Interceptor()
                )
            )
        )
        vc.factory = self
        return vc
    }

    func makeHomeViewController() -> HomeViewController {
        let vc = HomeViewController()
        vc.factory = self
        vc.reactor = HomeReactor(
            hourlyWeatherUseCase: DefaultHomeWeatherUseCase(
                weatherRepository: DefaultWeatherRepository(
                    weatherService: DefaultWeatherService()
                )
            )
        )
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

    func makeDecorationViewController(selectedImages: [UIImage]) -> DecorationViewController {
        let vc = DecorationViewController(selectedImages: selectedImages)
        vc.factory = self
        return vc
    }
}
