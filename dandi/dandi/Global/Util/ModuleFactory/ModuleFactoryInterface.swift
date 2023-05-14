//
//  ModuleFactoryInterface.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/31.
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
    func makeRegisterClothesViewController(selectedImage: UIImage) -> RegisterClothesViewController
    func makeClosetMainViewController() -> ClosetMainViewController
    func makePhotoLibraryViewController() -> PhotoLibraryViewController
    func makePostDetailViewController(postID: Int) -> PostDetailViewController
    func makeMyInformationViewController(userProfile: UserProfile) -> MyInformationViewController
    func makeDecorationViewController() -> DecorationViewController
    func makeUploadMainViewController(image: UIImage) -> UploadMainViewController
    func makeBackgroundTabViewController() -> BackgroundTabViewController
    func makeStickerTabViewController() -> StickerTabViewController
    func makeClosetTabViewController() -> ClosetTabViewController
    func makeLocationSettingViewController(from: LocationSettingViewController.From) -> LocationSettingViewController
    func makeConfirmLocationViewController(locality: String, latitude: Double, longitude: Double, from: LocationSettingViewController.From) -> ConfirmLocationViewController
    func makeDetailClothesViewController(id: Int) -> DetailClothesViewController
    func makeSettingViewController() -> SettingViewController
    func makeLikedHistoryViewController() -> LikeHistoryViewController
    func makeChatViewController() -> ChatViewController
}
