//
//  ClothesDetailAlertType.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/03.
//

import UIKit

enum ClothesDetailAlertType: AlertType {
    case delete

    var title: String {
        switch self {
        case .delete:
            return "삭제"
        }
    }

    var style: UIAlertAction.Style {
        switch self {
        case .delete:
            return .destructive
        }
    }
}
