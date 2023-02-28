//
//  Notification.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/28.
//

import Foundation

import UIKit

enum NotificationType {
    case heart
    case new
    case comment

    var image: UIImage {
        switch self {
        case .heart: return .add
        case .new: return .remove
        case .comment: return .actions
        }
    }
}

struct Notification {
    let uuid = UUID()
    let id: Int
    let title: String
    let description: String?
    let type: NotificationType
}

extension Notification: Equatable, Hashable {
    static func == (lhs: Notification, rhs: Notification) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
