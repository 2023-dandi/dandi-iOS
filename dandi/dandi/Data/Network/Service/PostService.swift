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
    case postPosts(post: PostDTO)
    case getDetailPost(id: Int)
}

extension PostService: BaseTargetType {
    var path: String {
        switch self {
        case .postImage:
            return "/posts/images"
        case .postPosts:
            return "/posts"
        case let .getDetailPost(id):
            return "/posts/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postImage, .postPosts:
            return .post
        case .getDetailPost:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case let .postImage(image):
            let imageData = image.jpegData(compressionQuality: .greatestFiniteMagnitude) ?? Data()
            let data = MultipartFormData(
                provider: .data(imageData),
                name: "post_image",
                fileName: "post_image.jpeg",
                mimeType: "image/jpeg"
            )
            return .uploadMultipart([data])
        case let .postPosts(post: post):
            return .requestJSONEncodable(post)
        case .getDetailPost:
            return .requestPlain
        }
    }
}
