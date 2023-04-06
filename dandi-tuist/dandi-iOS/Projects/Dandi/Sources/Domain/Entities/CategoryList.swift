//
//  CategoryList.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/03.
//

struct CategoryInfo {
    let category: ClothesCategory
    let seasons: [Season]
}

extension CategoryInfo: Equatable {
    public static func == (lhs: CategoryInfo, rhs: CategoryInfo) -> Bool {
        return lhs.category == rhs.category && lhs.seasons == rhs.seasons
    }
}
