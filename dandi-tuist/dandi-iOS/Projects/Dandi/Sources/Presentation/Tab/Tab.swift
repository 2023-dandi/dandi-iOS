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
    case feed = 1
    case my = 2

    var image: UIImage {
        switch self {
        case .home:
            return YDSIcon.homeLine
        case .feed:
            return YDSIcon.feedLine
        case .my:
            return YDSIcon.personLine
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
        }
    }

    var index: Int {
        return rawValue
    }
}
