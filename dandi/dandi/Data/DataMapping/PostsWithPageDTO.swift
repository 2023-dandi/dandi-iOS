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
    func toDomain() -> PostsWithPage {
        let posts = self.posts.compactMap { postDTO -> Post? in
            guard let id = postDTO.id else { return nil }
            return postDTO.toDomain(id: id)
        }

        return PostsWithPage(posts: posts, lastPage: lastPage)
    }
}
