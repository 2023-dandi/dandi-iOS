import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "DesignSystem",
    product: .framework,
    packages: [],
    dependencies: [.Project.Shared, .Project.ThirdPartyLib]
)
