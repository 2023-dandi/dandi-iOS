//
//  ClothesService.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/30.
//

import Foundation

import Moya

enum ClothesService {
    case postClothes(category: String, seasons: [String], clothesImageURL: String)
    case postClothesImage(imageData: Data)
    case deleteClothes(clothesID: Int)
    case getClothesList(size: Int, page: Int, category: String, seasons: [String])
    case getClothesCategory
    case getClothesDetail(clothesID: Int)
    case getRecommendedClothes(size: Int, page: Int)
}

extension ClothesService: BaseTargetType {
    var baseURL: URL {
        switch self {
        case let .getClothesList(size, page, category, seasons):
            var queryItems = [URLQueryItem]()
            queryItems.append(URLQueryItem(name: "category", value: category))
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
            queryItems.append(URLQueryItem(name: "size", value: "\(size)"))
            seasons.forEach { season in
                queryItems.append(URLQueryItem(name: "season", value: season))
            }

            var urlComponents = URLComponents()
            urlComponents.queryItems = queryItems

            let encodedQuery = urlComponents.percentEncodedQuery ?? ""
            let urlString = URLConstant.baseURL + "/clothes" + (encodedQuery.isEmpty ? "" : "?") + encodedQuery

            return URL(string: urlString)!

        default:
            return URL(string: URLConstant.baseURL)!
        }
    }

    var path: String {
        switch self {
        case .postClothes:
            return "/clothes"
        case .postClothesImage:
            return "/clothes/image"
        case let .deleteClothes(clothesID):
            return "/clothes/\(clothesID)"
        case .getClothesList:
            return ""
        case .getClothesCategory:
            return "/clothes/categories-seasons"
        case let .getClothesDetail(clothesID):
            return "/clothes/\(clothesID)"
        case .getRecommendedClothes:
            return "/clothes/today"
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
        case .getClothesCategory:
            return .get
        case .getClothesDetail:
            return .get
        case .getRecommendedClothes:
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
                fileName: "clothes_image.png",
                mimeType: "image/png"
            )
            return .uploadMultipart([data])

        case .deleteClothes:
            return .requestPlain

        case .getClothesList:
            return .requestPlain

        case .getClothesCategory:
            return .requestPlain

        case .getClothesDetail:
            return .requestPlain

        case let .getRecommendedClothes(size, page):
            return .requestParameters(
                parameters: ["size": size, "page": page],
                encoding: URLEncoding.queryString
            )
        }
    }
}
