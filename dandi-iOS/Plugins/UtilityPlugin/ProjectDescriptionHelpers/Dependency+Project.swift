import Foundation
import ProjectDescription

extension Dep {
    public struct Project { }
}

public extension Dep.Project {
    static let Presentation = Dep.project(target: "Presentation", path: .relativeToProject("Presentation"))
    static let Data = Dep.project(target: "Data", path: .relativeToProject("Data"))
    static let Domain = Dep.project(target: "Domain", path: .relativeToProject("Domain"))

    static let Shared = Dep.project(target: "Shared", path: .relativeToModule("Shared"))
    static let ThirdPartyLib = Dep.project(target: "ThirdPartyLib", path: .relativeToModule("ThirdPartyLib"))
    static let Network = Dep.project(target: "Network", path: .relativeToModule("Network"))
    static let DesignSystem = Dep.project(target: "DesignSystem", path: .relativeToModule("DesignSystem"))
}
