//
//  ClothesCategory.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/27.
//

import Foundation

enum ClothesCategory: Int, CaseIterable {
    case all = 0
    case top = 1
    case bottom = 2
    case outer = 3
    case onePiece = 4
    case shoes = 5
    case cap = 6
    case bag = 7
    case etc = 8

    var text: String {
        switch self {
        case .all: return "전체"
        case .top: return "상의"
        case .bottom: return "하의"
        case .outer: return "아우터"
        case .onePiece: return "원피스"
        case .shoes: return "신발"
        case .cap: return "모자"
        case .bag: return "가방"
        case .etc: return "기타"
        }
    }

    var toString: String {
        switch self {
        case .all: return "ALL"
        case .top: return "TOP"
        case .bottom: return "BOTTOM"
        case .outer: return "OUTER"
        case .onePiece: return "ONE_PIECE"
        case .shoes: return "SHOES"
        case .cap: return "CAP"
        case .bag: return "BAG"
        case .etc: return "ETC"
        }
    }

    static var allCases: [ClothesCategory] {
        return [.top, .bottom, .outer, .onePiece, .shoes, .cap, .bag, .etc]
    }
}
