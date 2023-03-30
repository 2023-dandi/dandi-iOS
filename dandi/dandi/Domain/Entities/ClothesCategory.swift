//
//  ClothesCategory.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/27.
//

import Foundation

enum ClothesCategory: Int, CaseIterable {
    case top = 0
    case bottom = 1
    case outer = 2
    case onePiece = 3
    case shoes = 4
    case cap = 5
    case bag = 6
    case etc = 7

    var text: String {
        switch self {
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
}
