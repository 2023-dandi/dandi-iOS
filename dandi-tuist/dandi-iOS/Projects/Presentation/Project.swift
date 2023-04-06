import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "Presentation",
    product: .staticFramework,
    dependencies: [.Project.Shared]
)
