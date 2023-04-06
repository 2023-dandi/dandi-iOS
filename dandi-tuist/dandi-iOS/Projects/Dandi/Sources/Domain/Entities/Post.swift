//
//  Post.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/03.
//

import Foundation

struct Post {
    let id: Int
    let mainImageURL: String
    let profileImageURL: String?
    let nickname: String
    let date: String
    let content: String
    let tag: [WeatherFeeling]
    let isLiked: Bool
    let isMine: Bool?
}

extension Post: Equatable, Hashable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
            && lhs.mainImageURL == rhs.mainImageURL
            && lhs.profileImageURL == rhs.profileImageURL
            && lhs.nickname == rhs.nickname
            && lhs.date == rhs.date
            && lhs.content == rhs.content
            && lhs.tag == rhs.tag
            && lhs.isLiked == rhs.isLiked
            && lhs.isMine == rhs.isMine
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
