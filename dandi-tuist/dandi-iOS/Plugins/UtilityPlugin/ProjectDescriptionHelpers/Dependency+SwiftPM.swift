//
//  Dependency+SwiftPM.swift
//  UtilityPlugin
//
//  Created by 김윤서 on 2022/12/26.
//

import Foundation
import ProjectDescription

public extension Dep {
    enum SPM {}
}

public extension Dep.SPM {
    static let Alamofire = Dep.package(product: "Alamofire")
    static let ReactorKit = Dep.package(product: "ReactorKit")
    static let RxSwift = Dep.package(product: "RxSwift")
    static let RxRelay = Dep.package(product: "RxRelay")
    static let RxMoya = Dep.package(product: "RxMoya")
    static let RxGesture = Dep.package(product: "RxGesture")
    static let Moya = Dep.package(product: "Moya")
    static let SnapKit = Dep.package(product: "SnapKit")
    static let Then = Dep.package(product: "Then")
    static let Kingfisher = Dep.package(product: "Kingfisher")
    static let YDS = Dep.package(product: "YDS")
    static let YPImagePicker = Dep.package(product: "YPImagePicker")
    static let BackgroundRemoval = Dep.package(product: "BackgroundRemoval")
}

public extension Package {
    static let Alamofire             = Package.remote(url: "https://github.com/Alamofire/Alamofire.git", requirement: .branch("master"))
    static let ReactorKit           = Package.remote(url: "https://github.com/ReactorKit/ReactorKit", requirement: .branch("3.2.0"))
    static let RxSwift              = Package.remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .exact("6.0.0") )
    static let RxGesture            = Package.remote(url: "https://github.com/RxSwiftCommunity/RxGesture.git", requirement: .exact("4.0.4"))
    static let Moya                 = Package.remote(url: "https://github.com/Moya/Moya.git", requirement: .exact("15.0.3"))
    static let SnapKit              = Package.remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .exact("5.6.0"))
    static let Then                 = Package.remote(url: "https://github.com/devxoul/Then.git", requirement: .exact("3.0.0"))
    static let Kingfisher           = Package.remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .exact("7.4.1"))
    static let YDS                  = Package.remote(url: "https://github.com/2023-dandi/YDS-iOS.git", requirement: .branch("main"))
    static let YPImagePicker        = Package.remote(url: "https://github.com/Yummypets/YPImagePicker.git", requirement: .exact( "5.0.0"))
    static let BackgroundRemoval    = Package.remote(url: "https://github.com/Ezaldeen99/BackgroundRemoval.git", requirement: .branch("main"))

}
