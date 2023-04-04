//
//  Clothes.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/02.
//

struct Clothes {
    let id: Int
    let imageURL: String
}

extension Clothes: Equatable {
    static func == (lhs: Clothes, rhs: Clothes) -> Bool {
        return lhs.id == rhs.id
    }
}
