//
//  ClothesCategoryDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/04.
//

import Foundation

struct ClothesCategoryListDTO: Decodable {
    let categories: [CategorySeasonsDTO]
}

extension ClothesCategoryListDTO {
    func toDomain() -> [CategoryInfo] {
        return categories.map { $0.toDomain() }
    }
}

struct CategorySeasonsDTO: Decodable {
    let category: ClothesCategoryDTO
    let seasons: [SeasonDTO]
}

extension CategorySeasonsDTO {
    func toDomain() -> CategoryInfo {
        var seasons: [Season] = seasons.map { $0.toDomain() }
        seasons.insert(.all, at: 0)
        return CategoryInfo(category: category.toDomain(), seasons: seasons)
    }
}

enum SeasonDTO: String, Decodable {
    case all = "ALL"
    case spring = "SPRING"
    case summer = "SUMMER"
    case fall = "FALL"
    case winter = "WINTER"

    func toDomain() -> Season {
        switch self {
        case .all: return Season.all
        case .spring: return Season.spring
        case .summer: return Season.summer
        case .fall: return Season.fall
        case .winter: return Season.winter
        }
    }
}

enum ClothesCategoryDTO: String, Decodable {
    case all = "ALL"
    case top = "TOP"
    case bottom = "BOTTOM"
    case outer = "OUTER"
    case onePiece = "ONE_PIECE"
    case shoes = "SHOES"
    case cap = "CAP"
    case bag = "BAG"
    case etc = "ETC"

    func toDomain() -> ClothesCategory {
        switch self {
        case .all: return ClothesCategory.all
        case .top: return ClothesCategory.top
        case .bottom: return ClothesCategory.bottom
        case .outer: return ClothesCategory.outer
        case .onePiece: return ClothesCategory.onePiece
        case .shoes: return ClothesCategory.onePiece
        case .cap: return ClothesCategory.cap
        case .bag: return ClothesCategory.bag
        case .etc: return ClothesCategory.etc
        }
    }
}
