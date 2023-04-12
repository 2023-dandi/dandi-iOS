//
//  Bundle+.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/12.
//

import Foundation

extension Bundle {
    static var appVersion: String {
        guard
            let version = main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        else {
            return ""
        }
        return version
    }
}
