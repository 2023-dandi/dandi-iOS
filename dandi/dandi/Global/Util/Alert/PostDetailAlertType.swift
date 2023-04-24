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
    case report
    case block

    var title: String {
        switch self {
        case .share:
            return "이미지 공유"
        case .delete:
            return "게시물 삭제"
        case .report:
            return "게시물 신고"
        case .block:
            return "사용자 차단"
        }
    }

    var style: UIAlertAction.Style {
        switch self {
        case .delete, .block, .report:
            return .destructive
        case .share:
            return .default
        }
    }
}
