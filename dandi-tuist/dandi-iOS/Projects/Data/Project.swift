import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "Data",
    product: .staticFramework,
    packages: [],
    dependencies: [.Project.Domain]
)
