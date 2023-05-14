//
//  NotificationsWithPage.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/27.
//

import Foundation

struct NotificationsWithPage: Decodable {
    let notifications: [NotificationModel]
    let lastPage: Bool
}

enum NotificationType: String, Decodable {
    case postLike = "POST_LIKE"
    case comment = "COMMENT"
    case weather = "WEATHER"
}

struct NotificationModel: Decodable {
    let id: Int
    let type: NotificationType
    let createdAt: String
    let checked: Bool
    let postID, commentID: Int
    let commentContent, weatherDate: String

    enum CodingKeys: String, CodingKey {
        case id, type, createdAt, checked
        case postID = "postId"
        case commentID = "commentId"
        case commentContent, weatherDate
    }
}

extension NotificationModel {
    func toDomain() -> NotificationItem {
        return NotificationItem(id: id, title: "", description: "", type: .comment)
    }
}
