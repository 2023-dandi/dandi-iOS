//
//  Comment.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/27.
//

import Foundation

struct Comment {
    let uuid = UUID()
    let id: Int
    let profileImageURL: String
    let nickname: String
    let date: String
    let content: String
    let isMine: Bool
    let isPostWriter: Bool

    init(
        id: Int,
        profileImageURL: String,
        nickname: String,
        date: String,
        content: String,
        isMine: Bool,
        isPostWriter: Bool
    ) {
        self.id = id
        self.profileImageURL = profileImageURL
        self.nickname = nickname
        self.date = TimeConverter.shared.convertDate(date: date)
        self.content = content
        self.isMine = isMine
        self.isPostWriter = isPostWriter
    }
}

extension Comment: Equatable, Hashable {
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    static func isSameContents(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id &&
            lhs.profileImageURL == rhs.profileImageURL &&
            lhs.nickname == rhs.nickname &&
            lhs.date == rhs.date &&
            lhs.content == rhs.content &&
            lhs.isMine == rhs.isMine &&
            lhs.isPostWriter == rhs.isPostWriter
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

extension Comment {
    func isChanged(from comment: Comment) -> Bool {
        return id == comment.id &&
            profileImageURL == comment.profileImageURL &&
            nickname == comment.nickname &&
            date == comment.date &&
            content == comment.content &&
            isMine == comment.isMine &&
            isPostWriter == comment.isPostWriter
    }
}
