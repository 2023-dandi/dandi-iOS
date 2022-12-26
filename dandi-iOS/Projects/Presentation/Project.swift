import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "Presentation",
    product: .framework,
    packages: [],
    dependencies: [.Project.DesignSystem]
)
