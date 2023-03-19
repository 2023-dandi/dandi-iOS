//
//  Post.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/03.
//

import Foundation

struct Post {
    let uuid = UUID()
    let id: Int
    let mainImageURL: String
    let profileImageURL: String?
    let nickname: String
    let date: String
    let content: String
    let tag: [WeatherFeeling]
    let isLiked: Bool
}

extension Post: Equatable, Hashable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
