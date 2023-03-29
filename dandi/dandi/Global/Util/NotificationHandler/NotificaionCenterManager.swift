//
//  NotificaionCenterManager.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/21.
//

import Foundation
import UIKit

enum NotificationCenterManager: NotificationCenterHandler {
    case reloadProfile
    case reloadLocation
    case reloadPosts
    case reloadPost

    var name: Notification.Name {
        switch self {
        case .reloadProfile:
            return Notification.Name("NotificationCenterManager.reloadProfile")
        case .reloadLocation:
            return Notification.Name("NotificationCenterManager.reloadLocation")
        case .reloadPosts:
            return Notification.Name("NotificationCenterManager.reloadPosts")
        case .reloadPost:
            return Notification.Name("NotificationCenterManager.reloadPost")
        }
    }
}
