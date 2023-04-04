//
//  Season.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/27.
//

import Foundation

enum Season: Int, CaseIterable {
    case all = 0
    case spring = 1
    case summer = 2
    case fall = 3
    case winter = 4

    var text: String {
        switch self {
        case .all: return "전체"
        case .spring: return "봄"
        case .summer: return "여름"
        case .fall: return "가을"
        case .winter: return "겨울"
        }
    }

    var toString: String {
        switch self {
        case .all: return "ALL"
        case .spring: return "SPRING"
        case .summer: return "SUMMER"
        case .fall: return "FALL"
        case .winter: return "WINTER"
        }
    }

    static var allCases: [Season] {
        return [.spring, .summer, .fall, .winter]
    }
}
