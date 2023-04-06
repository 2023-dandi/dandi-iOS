//
//  MemberService.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import Foundation

import Moya

enum MemberService {
    case putProfileImage(Data)
    case patchNickname(nickname: String)
    case patchLocation(latitude: Double, longitude: Double)
    case getMemberInfo
    case confirmNicknameDulication(nickname: String)
}

extension MemberService: BaseTargetType {
    var headers: [String: String]? {
        switch self {
        case .putProfileImage:
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
        case .putProfileImage:
            return "/members/profile-image"
        case .patchNickname:
            return "/members/nickname"
        case .patchLocation:
            return "/members/location"
        case .getMemberInfo:
            return "/members"
        case .confirmNicknameDulication:
            return "/members/nickname/duplication"
        }
    }

    var method: Moya.Method {
        switch self {
        case .putProfileImage:
            return .put
        case .patchNickname, .patchLocation:
            return .patch
        case .getMemberInfo, .confirmNicknameDulication:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case let .putProfileImage(imageData):
            let data = MultipartFormData(
                provider: .data(imageData),
                name: "profileImage",
                fileName: "profileImage.jpeg",
                mimeType: "image/jpeg"
            )
            return .uploadMultipart([data])

        case let .patchNickname(nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: JSONEncoding.default
            )

        case let .patchLocation(latitude, longitude):
            return .requestParameters(
                parameters: ["latitude": latitude, "longitude": longitude],
                encoding: JSONEncoding.default
            )

        case .getMemberInfo:
            return .requestPlain

        case let .confirmNicknameDulication(nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.queryString
            )
        }
    }
}
