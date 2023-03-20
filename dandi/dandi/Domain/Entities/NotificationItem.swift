//
//  NotificationItem.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/28.
//

import Foundation
import UIKit

import YDS

enum NotificationItemType {
    case heart
    case new
    case comment

    var image: UIImage {
        switch self {
        case .heart: return YDSIcon.heartLine
        case .new: return YDSIcon.newLine
        case .comment: return YDSIcon.commentLine
        }
    }
}

struct NotificationItem {
    let uuid = UUID()
    let id: Int
    let title: String
    let description: String?
    let type: NotificationItemType
}

extension NotificationItem: Equatable, Hashable {
    static func == (lhs: NotificationItem, rhs: NotificationItem) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
