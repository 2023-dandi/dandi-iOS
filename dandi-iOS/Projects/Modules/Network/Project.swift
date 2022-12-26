import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "Network",
    product: .framework,
    packages: [],
    dependencies: [.Project.Shared]
)
