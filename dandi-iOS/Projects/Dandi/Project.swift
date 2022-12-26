import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "Dandi-iOS",
    product: .app,
    packages: [],
    dependencies: [.Project.Presentation, .Project.Data]
)
