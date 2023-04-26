//
//  DeleteAlertType.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/26.
//

import UIKit

enum DeleteAlertType: AlertType {
    case delete
    case cancel

    var title: String {
        switch self {
        case .delete:
            return "삭제"
        case .cancel:
            return "취소"
        }
    }

    var style: UIAlertAction.Style {
        switch self {
        case .delete:
            return .destructive
        case .cancel:
            return .cancel
        }
    }
}
