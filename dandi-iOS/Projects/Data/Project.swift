import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "Data",
    product: .framework,
    packages: [],
    dependencies: [.Project.Domain, .Project.Network]
)
