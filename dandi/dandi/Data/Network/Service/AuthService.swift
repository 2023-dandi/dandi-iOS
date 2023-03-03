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
}

extension AuthService: BaseTargetType {
    var path: String {
        switch self {
        case .refresh:
            return "/refresh"
        case .login:
            return "/login/oauth/apple"
        }
    }

    var method: Moya.Method {
        switch self {
        case .refresh:
            return .post
        case .login:
            return .post
        }
    }

    var task: Task {
        return .requestPlain
    }
}
