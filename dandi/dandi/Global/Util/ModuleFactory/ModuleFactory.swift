//
//  ModuleFactory.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import Foundation
import UIKit

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
        let authRepository = DefaultAuthRepository(interceptor: Interceptor())
        let authUseCase = DefaultAuthUseCase(authRepository: authRepository)
        vc.reactor = LoginReactor(authUseCase: authUseCase)
        vc.factory = self
        return vc
    }

    func makeHomeViewController() -> HomeViewController {
        let vc = HomeViewController()

        let postRepository = DefaultPostRepository(interceptor: Interceptor())
        let weatherRepository = DefaultWeatherRepository(weatherService: DefaultWeatherService())
        let clothesRepository = DefaultClothesRepository(interceptor: Interceptor())

        let postListUseCase = MyTemperaturePostListUseCase(postRepository: postRepository)
        let temperatureUseCase = DefaultTemperatureUseCase(weatherRepository: weatherRepository)
        let postLikeUseCase = DefaultPostLikeUseCase(postRepository: postRepository)
        let hourlyWeatherUseCase = DefaultHourlyWeatherUseCase(weatherRepository: weatherRepository)
        let closetUseCase = DefaultClosetUseCase(clothesRepository: clothesRepository)

        vc.reactor = HomeReactor(
            postLikeUseCase: postLikeUseCase,
            hourlyWeatherUseCase: hourlyWeatherUseCase,
            postListUseCase: postListUseCase,
            temperatureUseCase: temperatureUseCase,
            closetUseCase: closetUseCase
        )
        vc.factory = self
        return vc
    }

    func makeHomeButtonViewController() -> HomeButtonViewController {
        let vc = HomeButtonViewController()
        vc.factory = self
        return vc
    }

    func makeMyPageViewController() -> MyPageViewController {
        let vc = MyPageViewController()
        let locationConverter = LocationConverter()

        let memberRepository = DefaultMemberRepository(interceptor: Interceptor())
        let postRepository = DefaultPostRepository(interceptor: Interceptor())

        let memberInfoUseCase = DefaultMemberInfoUseCase(memberRepository: memberRepository, converter: locationConverter)
        let postListUseCase = DefaultMyPostsUseCase(postRepository: postRepository)

        vc.reactor = MyPageReactor(memberInfoUseCase: memberInfoUseCase, postListUseCase: postListUseCase)
        vc.factory = self

        return vc
    }

    func makeFeedViewContontoller() -> FeedViewController {
        let postRepository = DefaultPostRepository(interceptor: Interceptor())
        let weatherRepository = DefaultWeatherRepository(weatherService: DefaultWeatherService())

        let postListUseCase = DefaultPostListUseCase(postRepository: postRepository)
        let postLikeUseCase = DefaultPostLikeUseCase(postRepository: postRepository)
        let temperatureUseCase = DefaultTemperatureUseCase(weatherRepository: weatherRepository)

        let vc = FeedViewController()
        vc.reactor = FeedReactor(
            postListUseCase: postListUseCase,
            postLikeUseCase: postLikeUseCase,
            temperatureUseCase: temperatureUseCase
        )
        vc.factory = self
        return vc
    }

    func makeRegisterClothesViewController(selectedImage: UIImage) -> RegisterClothesViewController {
        let clothesRepository = DefaultClothesRepository(interceptor: Interceptor())

        let vc = RegisterClothesViewController(selectedImage: selectedImage)
        vc.reactor = RegisterClothesReactor(
            imageUseCase: UploadClothesImageUseCase(clothesRepository: clothesRepository),
            clothesUseCase: DefaultRegisterClothesUseCase(clothesRepository: clothesRepository)
        )
        vc.factory = self
        return vc
    }

    func makePhotoLibraryViewController() -> PhotoLibraryViewController {
        let vc = PhotoLibraryViewController()
        vc.factory = self
        return vc
    }

    func makePostDetailViewController(postID: Int) -> PostDetailViewController {
        let postRepository = DefaultPostRepository(interceptor: Interceptor())
        let commentRepository = DefaultCommentRepository(interceptor: Interceptor())
        let memberRepository = DefaultMemberRepository(interceptor: Interceptor())

        let detailUseCase = DefaultPostDetailUseCase(postRepository: postRepository)
        let likeUseCase = DefaultPostLikeUseCase(postRepository: postRepository)
        let commentUseCase = DefaultCommentUseCase(commentRepository: commentRepository)
        let reportAndBlockUseCase = DefaultReportAndBlockUseCase(
            commentRepository: commentRepository,
            postRepository: postRepository,
            memberRepository: memberRepository
        )

        let vc = PostDetailViewController()
        vc.reactor = PostDetailReactor(
            postID: postID,
            postDetailUseCase: detailUseCase,
            postLikeUseCase: likeUseCase,
            commentUseCase: commentUseCase,
            reportAndBlockUseCase: reportAndBlockUseCase
        )
        vc.factory = self
        return vc
    }

    func makeClosetMainViewController() -> ClosetMainViewController {
        let vc = ClosetMainViewController()
        let clothesRepository = DefaultClothesRepository(interceptor: Interceptor())
        let closetUseCase = DefaultClosetUseCase(clothesRepository: clothesRepository)
        let reactor = ClosetTabReactor(closetUseCase: closetUseCase)
        vc.reactor = reactor
        vc.factory = self
        return vc
    }

    func makeMyInformationViewController(userProfile: UserProfile) -> MyInformationViewController {
        let memberRepository = DefaultMemberRepository(interceptor: Interceptor())

        let nicknameUseCase = DefaultNicknameUseCase(memberRepository: memberRepository)
        let imageUseCase = UploadProfileImageUseCase(memberRepository: memberRepository)

        let vc = MyInformationViewController()
        vc.reactor = MyInformationReactor(
            userProfile: userProfile,
            nicknameUseCase: nicknameUseCase,
            imageUseCase: imageUseCase
        )
        vc.factory = self
        return vc
    }

    func makeDecorationViewController() -> DecorationViewController {
        return DecorationViewController(factory: self)
    }

    func makeUploadMainViewController(image: UIImage) -> UploadMainViewController {
        let postRepository = DefaultPostRepository(interceptor: Interceptor())
        let weatherRepository = DefaultWeatherRepository(weatherService: DefaultWeatherService())

        let weatherUseCase = DefaultTemperatureUseCase(weatherRepository: weatherRepository)
        let uploadUseCase = DefaultUploadPostUseCase(postRepository: postRepository)
        let imageUseCase = UploadPostImageUseCase(postRepository: postRepository)

        let reactor = UploadMainReactor(
            weatherUseCase: weatherUseCase,
            uploadUseCase: uploadUseCase,
            imageUseCase: imageUseCase
        )

        let vc = UploadMainViewController(image: image)
        vc.reactor = reactor
        vc.factory = self
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
        let clothesRepository = DefaultClothesRepository(interceptor: Interceptor())
        let closetUseCase = DefaultClosetUseCase(clothesRepository: clothesRepository)
        let reactor = ClosetTabReactor(closetUseCase: closetUseCase)
        vc.reactor = reactor
        return vc
    }

    func makeLocationSettingViewController(from: LocationSettingViewController.From) -> LocationSettingViewController {
        let vc = LocationSettingViewController(from: from)
        vc.factory = self
        return vc
    }

    func makeConfirmLocationViewController(
        locality: String,
        latitude: Double,
        longitude: Double,
        from: LocationSettingViewController.From
    ) -> ConfirmLocationViewController {
        let vc = ConfirmLocationViewController(
            locality: locality,
            latitude: latitude,
            longitude: longitude,
            from: from
        )
        vc.factory = self
        let memberRepository = DefaultMemberRepository(interceptor: Interceptor())
        let locationUseCase = DefaultLocationUseCase(memberRepository: memberRepository)
        vc.reactor = ConfirmLocationReactor(locationUseCase: locationUseCase)
        return vc
    }

    func makeDetailClothesViewController(id: Int) -> DetailClothesViewController {
        let vc = DetailClothesViewController()
        vc.factory = self
        let clothesRepository = DefaultClothesRepository(interceptor: Interceptor())
        let closetUseCase = DefaultClosetUseCase(clothesRepository: clothesRepository)
        let reactor = DetailClothesReactor(id: id, clothesUseCase: closetUseCase)
        vc.reactor = reactor
        return vc
    }

    func makeSettingViewController() -> SettingViewController {
        let vc = SettingViewController()
        vc.factory = self
        return vc
    }
}
