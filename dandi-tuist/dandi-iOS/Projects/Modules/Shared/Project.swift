import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "Shared",
    product: .staticFramework,
    dependencies: [.Project.ThirdPartyLib]
)
