//
//  ModuleFactory.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import Foundation
import UIKit

import YPImagePicker

protocol ModuleFactoryInterface {
    func makeSplahViewController() -> SplashViewController
    func makeTabBarViewController() -> MainTabBarController
    func makeLoginViewController() -> LoginViewController
    func makeHomeViewController() -> HomeViewController
    func makeHomeButtonViewController() -> HomeButtonViewController
    func makeMyPageViewController() -> MyPageViewController
    func makeFeedViewContontoller() -> FeedViewController
    func makeRegisterClothesViewController(selectedImages: [UIImage]) -> RegisterClothesViewController
    func makeClosetMainViewController() -> ClosetMainViewController
    func makePhotoLibraryViewController() -> PhotoLibraryViewController
    func makePostDetailViewController(postID: Int) -> PostDetailViewController
    func makeMyInformationViewController(userProfile: UserProfile) -> MyInformationViewController
    func makeDecorationViewController() -> DecorationViewController
    func makeUploadMainViewController(image: UIImage) -> UploadMainViewController
    func makeBackgroundTabViewController() -> BackgroundTabViewController
    func makeStickerTabViewController() -> StickerTabViewController
    func makeClosetTabViewController() -> ClosetTabViewController
    func makeLocationSettingViewController() -> LocationSettingViewController
}

final class ModuleFactory {
    static let shared = ModuleFactory()
    private init() {}
}

extension ModuleFactory: ModuleFactoryInterface {
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
            hourlyWeatherUseCase: DefaultHourlyWeatherUseCase(
                weatherRepository: DefaultWeatherRepository(
                    weatherService: DefaultWeatherService()
                )
            )
        )
        return vc
    }

    func makeHomeButtonViewController() -> HomeButtonViewController {
        let vc = HomeButtonViewController()
        vc.factory = self
        return vc
    }

    func makeMyPageViewController() -> MyPageViewController {
        let vc = MyPageViewController()
        vc.factory = self
        vc.reactor = MyPageReactor(
            memberInfoUseCase: DefaultMemberInfoUseCase(
                memberRepository: DefaultMemberRepository(interceptor: Interceptor()),
                converter: LocationConverter()
            ),
            postListUseCase: DefaultMyPostsUseCase(
                postRepository: DefaultPostRepository(interceptor: Interceptor())
            )
        )
        return vc
    }

    func makeFeedViewContontoller() -> FeedViewController {
        let vc = FeedViewController()
        vc.reactor = FeedReactor(
            postListUseCase: DefaultPostListUseCase(postRepository: DefaultPostRepository(interceptor: Interceptor())),
            postLikeUseCase: DefaultPostLikeUseCase(postRepository: DefaultPostRepository(interceptor: Interceptor())),
            temperatureUseCase: DefaultTemperatureUseCase(weatherRepository: DefaultWeatherRepository(weatherService: DefaultWeatherService()))
        )
        vc.factory = self
        return vc
    }

    func makeRegisterClothesViewController(selectedImages: [UIImage]) -> RegisterClothesViewController {
        let vc = RegisterClothesViewController(selectedImages: selectedImages)
        vc.factory = self
        return vc
    }

    func makePhotoLibraryViewController() -> PhotoLibraryViewController {
        let vc = PhotoLibraryViewController()
        vc.factory = self
        return vc
    }

    func makePostDetailViewController(postID: Int) -> PostDetailViewController {
        let vc = PostDetailViewController(postID: postID)
        vc.factory = self
        vc.reactor = PostDetailReactor(
            postDetailUseCase: DefaultPostDetailUseCase(
                postRepository: DefaultPostRepository(
                    interceptor: Interceptor()
                )
            ),
            postLikeUseCase: DefaultPostLikeUseCase(
                postRepository: DefaultPostRepository(
                    interceptor: Interceptor()
                )
            )
        )
        return vc
    }

    func makeClosetMainViewController() -> ClosetMainViewController {
        let vc = ClosetMainViewController()
        vc.factory = self
        return vc
    }

    func makeMyInformationViewController(userProfile: UserProfile) -> MyInformationViewController {
        let vc = MyInformationViewController()
        vc.factory = self
        vc.reactor = MyInformationReactor(
            userProfile: userProfile,
            nicknameUseCase: DefaultNicknameUseCase(
                memberRepository: DefaultMemberRepository(
                    interceptor: Interceptor(
                    )
                )
            ),
            imageUseCase: DefaultProfileImageUseCase(
                memberRepository: DefaultMemberRepository(
                    interceptor: Interceptor()
                )
            )
        )
        return vc
    }

    func makeDecorationViewController() -> DecorationViewController {
        let vc = DecorationViewController(factory: self)
        return vc
    }

    func makeUploadMainViewController(image: UIImage) -> UploadMainViewController {
        let vc = UploadMainViewController(image: image)
        vc.factory = self
        vc.reactor = UploadMainReactor(
            weatherUseCase: DefaultTemperatureUseCase(
                weatherRepository: DefaultWeatherRepository(weatherService: DefaultWeatherService())
            ),
            uploadUseCase: DefaultUploadUseCase(
                postRepository: DefaultPostRepository(interceptor: Interceptor())
            )
        )
        return vc
    }

    func makeBackgroundTabViewController() -> BackgroundTabViewController {
        let vc = BackgroundTabViewController()
        vc.factory = self
        return vc
    }

    func makeStickerTabViewController() -> StickerTabViewController {
        let vc = StickerTabViewController()
        vc.factory = self
        return vc
    }

    func makeClosetTabViewController() -> ClosetTabViewController {
        let vc = ClosetTabViewController()
        vc.factory = self
        return vc
    }

    func makeLocationSettingViewController() -> LocationSettingViewController {
        let vc = LocationSettingViewController()
        vc.factory = self
        return vc
    }
}
