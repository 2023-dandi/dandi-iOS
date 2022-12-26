import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "ThirdPartyLib",
    product: .framework,
    packages: [
        .ReactorKit,
        .RxSwift
    ],
    dependencies: []
)
