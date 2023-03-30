//
//  ClothesService.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/30.
//

import UIKit

import Moya

enum ClothesService {
    case postClothes(category: String, seasons: [String], clothesImageURL: String)
    case postClothesImage(imageData: Data)
    case deleteClothes(clothesID: Int)
}

extension ClothesService: BaseTargetType {
    var path: String {
        switch self {
        case .postClothes:
            return "/clothes"
        case .postClothesImage:
            return "/clothes/image"
        case let .deleteClothes(clothesID):
            return "/clothes/\(clothesID)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postClothes:
            return .post
        case .postClothesImage:
            return .post
        case .deleteClothes:
            return .delete
        }
    }

    var task: Moya.Task {
        switch self {
        case let .postClothes(category, seasons, clothesImageURL):
            return .requestParameters(
                parameters: [
                    "category": category,
                    "seasons": seasons,
                    "clothesImageUrl": clothesImageURL
                ],
                encoding: JSONEncoding.default
            )
        case let .postClothesImage(imageData):
            let data = MultipartFormData(
                provider: .data(imageData),
                name: "clothesImage",
                fileName: "clothes_image.jpeg",
                mimeType: "image/jpeg"
            )
            return .uploadMultipart([data])
        case .deleteClothes:
            return .requestPlain
        }
    }
}
