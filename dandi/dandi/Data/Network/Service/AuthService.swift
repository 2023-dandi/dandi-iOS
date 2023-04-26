//
//  AuthService.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/03.
//

import Moya

enum AuthService {
    case refresh(refreshToken: String, accessToken: String)
    case login(idToken: String)
    case logout
    case witdraw
}

extension AuthService: BaseTargetType {
    var headers: [String: String]? {
        switch self {
        case .login:
            return [
                "Content-Type": "application/json"
            ]
        default:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaultHandler.shared.accessToken)"
            ]
        }
    }

    var path: String {
        switch self {
        case .refresh:
            return "/auth/refresh"
        case .login:
            return "/auth/login/oauth/apple"
        case .logout:
            return "/auth/logout"
        case .witdraw:
            return "/auth/withdraw"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var task: Task {
        switch self {
        case let .login(idToken):
            return .requestParameters(
                parameters: ["idToken": idToken],
                encoding: JSONEncoding.default
            )
        default:
            return .requestPlain
        }
    }
}
