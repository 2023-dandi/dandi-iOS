import Foundation
import ProjectDescription

public extension ProjectDescription.Path {
    static func relativeToModule(_ pathString: String) -> Self {
        return .relativeToRoot("Projects/Modules/\(pathString)")
    }
    static func relativeToProject(_ pathString: String) -> Self {
        return .relativeToRoot("Projects/\(pathString)")
    }
}
