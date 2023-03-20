//
//  NotificationCenterHandler.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/21.
//

import Foundation
import RxSwift

protocol NotificationCenterHandler {
    var name: Notification.Name { get }
}

extension NotificationCenterHandler {
    func addObserver() -> Observable<Any?> {
        return NotificationCenter.default.rx.notification(name).map { $0.object }
    }

    func post(object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: nil)
    }
}
