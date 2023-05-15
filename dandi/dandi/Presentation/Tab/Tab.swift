//
//  Tab.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import UIKit

import YDS

enum Tab: Int, CaseIterable {
    case home = 0
    case closet = 1
    case feed = 2
    case chat = 3
    case my = 4

    var image: UIImage {
        switch self {
        case .home:
            return YDSIcon.homeLine
        case .feed:
            return YDSIcon.feedLine
        case .my:
            return YDSIcon.personLine
        case .closet:
            return Image.closetLine.resize(newWidth: 21)
        case .chat:
            return YDSIcon.commentLine.resize(newWidth: 21)
        }
    }

    var selectedImage: UIImage {
        switch self {
        case .home:
            return YDSIcon.homeFilled
        case .feed:
            return YDSIcon.feedFilled
        case .my:
            return YDSIcon.personFilled
        case .closet:
            return Image.closetFilled.resize(newWidth: 21)
        case .chat:
            return YDSIcon.commentFilled.resize(newWidth: 21)
        }
    }

    var index: Int {
        return rawValue
    }
}
