import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "ThirdPartyLib",
    product: .framework,
    packages: [
        .Alamofire,
        .BackgroundRemoval,
        .Moya,
        .YPImagePicker,
        .Kingfisher,
        .YDS,
        .RxGesture,
        .ReactorKit,
        .RxSwift,
        .SnapKit,
        .Then,
        .Kingfisher
    ],
    dependencies: [
        .SPM.Alamofire,
        .SPM.BackgroundRemoval,
        .SPM.Moya,
        .SPM.YPImagePicker,
        .SPM.Kingfisher,
        .SPM.YDS,
        .SPM.RxGesture,
        .SPM.ReactorKit,
        .SPM.RxSwift,
        .SPM.SnapKit,
        .SPM.Then,
        .SPM.Kingfisher,
        .SPM.RxMoya
    ]
)
