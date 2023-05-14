//
//  GPTService.swift
//  dandi
//
//  Created by 김윤서 on 2023/05/14.
//

import Foundation

import Moya

enum GPTService {
    case postContent(_ content: String)
}

extension GPTService: BaseTargetType {
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(URLConstant.gptToken)"
        ]
    }

    var baseURL: URL {
        return URL(string: "https://api.openai.com/v1")!
    }

    var path: String {
        switch self {
        case .postContent:
            return "/chat/completions"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postContent:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case let .postContent(content):
            let model = GPTChatRequest(
                messages: [GPTChatMessage(role: "user", content: content)],
                model: "gpt-3.5-turbo-0301"
            )
            return .requestJSONEncodable(model)
        }
    }
}
