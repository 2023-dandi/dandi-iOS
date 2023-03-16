//
//  ClothesFeeling.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/16.
//

enum ClothesFeeling: Int, CaseIterable {
    case soCold = 0
    case cold = 1
    case great = 2
    case hot = 3
    case soHot = 4

    var text: String {
        switch self {
        case .soCold:
            return "너무 추워요"
        case .cold:
            return "추워요"
        case .great:
            return "딱 좋아요"
        case .hot:
            return "더워요"
        case .soHot:
            return "너무 더워요"
        }
    }
}
