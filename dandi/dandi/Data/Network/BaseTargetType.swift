//
//  BaseTargetType.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/03.
//

import Foundation
import Moya

protocol BaseTargetType: TargetType {}

extension BaseTargetType {
    var baseURL: URL {
        return URL(string: Environment.baseURL)!
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(KeychainHandler.shared.accessToken)"
        ]
    }

    var validationType: ValidationType {
        return .successCodes
    }

    var sampleData: Data {
        return Data()
    }
}
