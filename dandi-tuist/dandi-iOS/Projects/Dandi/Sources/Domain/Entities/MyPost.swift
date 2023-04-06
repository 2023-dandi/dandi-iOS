//
//  MyPost.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

struct MyPost: Decodable {
    let id: Int
    let postImageUrl: String
}

extension MyPost: Equatable, Hashable {
    static func == (lhs: MyPost, rhs: MyPost) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
