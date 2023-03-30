//
//  Season.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/27.
//

import Foundation

enum Season: Int, CaseIterable {
    case spring = 0
    case summer = 1
    case fall = 2
    case winter = 3

    var text: String {
        switch self {
        case .spring: return "봄"
        case .summer: return "여름"
        case .fall: return "가을"
        case .winter: return "겨울"
        }
    }

    var toString: String {
        switch self {
        case .spring: return "SPRING"
        case .summer: return "SUMMER"
        case .fall: return "FALL"
        case .winter: return "WINTER"
        }
    }
}
