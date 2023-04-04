//
//  CommentService.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/04.
//

import Foundation

import Moya

enum CommentService {
    case getComments(postID: Int)
    case postComment(postID: Int, content: String)
    case deleteComment(postID: Int, commentID: Int)
}

extension CommentService: BaseTargetType {
    var path: String {
        switch self {
        case let .getComments(postID):
            return "/posts/\(postID)/comments"
        case let .postComment(postID, _):
            return "/posts/\(postID)/comments"
        case let .deleteComment(postID, commentID):
            return "/posts/\(postID)/comments/\(commentID)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getComments:
            return .get
        case .postComment:
            return .post
        case .deleteComment:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case .getComments:
            return .requestPlain
        case let .postComment(_, content):
            return .requestParameters(
                parameters: ["content": content],
                encoding: JSONEncoding.default
            )
        case .deleteComment:
            return .requestPlain
        }
    }
}
