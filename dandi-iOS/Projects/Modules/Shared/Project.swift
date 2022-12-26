import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "Shared",
    product: .framework,
    packages: [],
    dependencies: [.Project.ThirdPartyLib]
)
