//
//  PostDetailAlertType.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

enum PostDetailAlertType: AlertType {
    case delete
    case share

    var title: String {
        switch self {
        case .share:
            return "이미지 공유"
        case .delete:
            return "게시물 삭제"
        }
    }

    var style: UIAlertAction.Style {
        switch self {
        case .delete:
            return .destructive
        case .share:
            return .default
        }
    }
}
