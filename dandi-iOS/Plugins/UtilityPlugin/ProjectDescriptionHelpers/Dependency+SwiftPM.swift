//
//  Dependency+SwiftPM.swift
//  UtilityPlugin
//
//  Created by 김윤서 on 2022/12/26.
//

import Foundation
import ProjectDescription

extension Dep {
    public struct SwiftPM { }
}

public extension Dep.SwiftPM {
    static let Alamofire             = Dep.package(product: "Alamofire")
    static let InjectPropertyWrapper = Dep.package(product: "InjectPropertyWrapper")
    static let ReactorKit            = Dep.package(product: "ReactorKit")
    static let RIBs                  = Dep.package(product: "RIBs")
    static let RxCocoa               = Dep.package(product: "RxCocoa")
    static let RxRelay               = Dep.package(product: "RxRelay")
    static let RxSwift               = Dep.package(product: "RxSwift")
    static let Swinject              = Dep.package(product: "Swinject")
}

public extension Package {
    static let Alamofire             = Package.package(url: "https://github.com/Alamofire/Alamofire.git", .branch("master"))
    static let InjectPropertyWrapper = Package.package(url: "https://github.com/egeniq/InjectPropertyWrapper.git", .branch("master"))
    static let ReactorKit            = Package.package(url: "https://github.com/ReactorKit/ReactorKit.git", .branch("master"))
    static let RIBs                  = Package.package(url: "https://github.com/uber/RIBs.git", .branch("master"))
    static let RxSwift               = Package.package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.0.0")
    static let Swinject              = Package.package(url: "https://github.com/Swinject/Swinject.git", .branch("master"))
}
