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
    case onepiece = 3
    case shoes = 4
    case hat = 5
    case bag = 6
    case etc = 7

    var text: String {
        switch self {
        case .top: return "상의"
        case .bottom: return "하의"
        case .outer: return "아우터"
        case .onepiece: return "원피스"
        case .shoes: return "신발"
        case .hat: return "모자"
        case .bag: return "가방"
        case .etc: return "기타"
        }
    }
}
