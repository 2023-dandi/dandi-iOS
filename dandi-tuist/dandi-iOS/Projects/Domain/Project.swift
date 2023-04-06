import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "Domain",
    product: .staticFramework,
    packages: [],
    dependencies: [.Project.Shared]
)
