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

    var name: Notification.Name {
        switch self {
        case .reloadProfile:
            return Notification.Name("NotificationCenterManager.reloadProfile")
        }
    }
}
