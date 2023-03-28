//
//  PostContentDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

struct PostsWithPageDTO: Decodable {
    let posts: [PostContentDTO]
    let lastPage: Bool
}

extension PostsWithPageDTO {
    func toDomain() -> [Post] {
        return posts.map { $0.toDomain() }
    }
}
