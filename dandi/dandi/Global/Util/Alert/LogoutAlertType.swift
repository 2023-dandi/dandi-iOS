//
//  LogoutAlertType.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/12.
//

import UIKit

enum LogoutAlertType: AlertType {
    case logout
    case cancel

    var title: String {
        switch self {
        case .logout:
            return "로그아웃"
        case .cancel:
            return "취소"
        }
    }

    var style: UIAlertAction.Style {
        switch self {
        case .logout:
            return .default
        case .cancel:
            return .cancel
        }
    }
}
