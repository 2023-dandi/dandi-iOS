//
//  ClothesInfo.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/31.
//

import UIKit

struct ClothesInfo {
    let category: ClothesCategory
    let seasons: [Season]
    let image: UIImage
}

struct ClothesDetailInfo {
    let id: Int
    let imageURL: String
    let category: ClothesCategory
    let seasons: [Season]
}

extension ClothesDetailInfo: Equatable {
    static func == (lhs: ClothesDetailInfo, rhs: ClothesDetailInfo) -> Bool {
        return lhs.id == rhs.id
    }
}
