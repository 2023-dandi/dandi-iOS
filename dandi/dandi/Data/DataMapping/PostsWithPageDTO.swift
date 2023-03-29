//
//  PostsWithPageDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/29.
//

import Foundation

struct PostsWithPageDTO: Decodable {
    let posts: [PostDTO]
    let lastPage: Bool
}

extension PostsWithPageDTO {
    func toDomain() -> [Post] {
        return posts.map { $0.toDomain() }
    }
}
