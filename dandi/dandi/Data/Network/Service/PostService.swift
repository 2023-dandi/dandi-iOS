//
//  PostService.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

import Moya
import UIKit

enum PostService {
    case postImage(image: UIImage)
    case postPosts(post: PostContentDTO)
    case getDetailPost(id: Int)
    case like(id: Int)
    case deletePost(id: Int)
    case my
    case feed(min: Int, max: Int, size: Int, page: Int)
}

extension PostService: BaseTargetType {
    var headers: [String: String]? {
        switch self {
        case .postImage:
            return [
                "Content-Type": "multipart/form-data",
                "Authorization": "Bearer \(UserDefaultHandler.shared.accessToken)"
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
        case .postImage:
            return "/posts/images"
        case .postPosts:
            return "/posts"
        case let .getDetailPost(id):
            return "/posts/\(id)"
        case let .like(id):
            return "/posts/\(id)/likes"
        case let .deletePost(id):
            return "/posts/\(id)"
        case .my:
            return "/posts/my"
        case .feed:
            return "posts/feed/weather"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postImage, .postPosts:
            return .post
        case .getDetailPost:
            return .get
        case .like:
            return .patch
        case .deletePost:
            return .delete
        case .my:
            return .get
        case .feed:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case let .postImage(image):
            let imageData = image.jpegData(compressionQuality: .greatestFiniteMagnitude) ?? Data()
            let data = MultipartFormData(
                provider: .data(imageData),
                name: "postImage",
                fileName: "post_image.jpeg",
                mimeType: "image/jpeg"
            )
            return .uploadMultipart([data])

        case let .postPosts(post: post):
            return .requestJSONEncodable(post)

        case .getDetailPost:
            return .requestPlain

        case .like:
            return .requestPlain

        case .deletePost:
            return .requestPlain

        case .my:
            return .requestPlain

        case let .feed(min, max, size, page):
            return .requestParameters(
                parameters: ["min": min, "max": max, "size": size, "page": page, "sort": "createdAt,DESC"],
                encoding: URLEncoding.queryString
            )
        }
    }
}
