//
//  WithdrawAlertType.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/12.
//

import UIKit

enum WithdrawAlertType: AlertType {
    case withdraw
    case cancel

    var title: String {
        switch self {
        case .withdraw:
            return "탈퇴"
        case .cancel:
            return "취소"
        }
    }

    var style: UIAlertAction.Style {
        switch self {
        case .withdraw:
            return .destructive
        case .cancel:
            return .cancel
        }
    }
}
