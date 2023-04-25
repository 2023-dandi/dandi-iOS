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
    let writerId: Int
    let nickname: String
    let date: String
    let content: String
    let tag: [WeatherFeeling]
    let isLiked: Bool
    let isMine: Bool?

    init(
        id: Int,
        mainImageURL: String,
        profileImageURL: String?,
        writerId: Int,
        nickname: String,
        date: String,
        content: String,
        tag: [WeatherFeeling],
        isLiked: Bool,
        isMine: Bool?
    ) {
        self.id = id
        self.mainImageURL = mainImageURL
        self.profileImageURL = profileImageURL
        self.writerId = writerId
        self.nickname = nickname
        self.date = TimeConverter.shared.convertDate(date: date)
        self.content = content
        self.tag = tag
        self.isLiked = isLiked
        self.isMine = isMine
    }
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
