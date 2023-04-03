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
    case getClothesList(size: Int, page: Int, category: String, seasons: [String])
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
        case .getClothesList:
            return "/clothes"
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
        case .getClothesList:
            return .get
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
        case let .getClothesList(size, page, category, seasons):
            var parameters: [String: Any] = [
                "size": size,
                "page": page,
                "category": category
            ]
            seasons.forEach {
                parameters["season"] = $0
            }
            return .requestParameters(
                parameters: parameters,
                encoding: URLEncoding.queryString
            )
        }
    }
}
