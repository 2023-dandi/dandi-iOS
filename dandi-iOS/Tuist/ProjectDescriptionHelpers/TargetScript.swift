//
//  Script.swift
//  ProjectDescription
//
//  Created by 김윤서 on 2022/12/26.
//

import ProjectDescription

extension TargetScript {
    static let swiftlint = TargetScript.pre(
        script: """
        if test -d "/opt/homebrew/bin/"; then
            PATH="/opt/homebrew/bin/:${PATH}"
        fi
        export PATH
        if which swiftlint > /dev/null; then
            swiftlint
        else
            echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
        fi
        """,
        name: "SwiftLintString",
        basedOnDependencyAnalysis: false
    )
}
