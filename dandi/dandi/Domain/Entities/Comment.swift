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
}

extension Comment: Equatable, Hashable {
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
