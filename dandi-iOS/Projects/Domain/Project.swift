import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "Domain",
    product: .framework,
    packages: [],
    dependencies: [.Project.Shared]
)
