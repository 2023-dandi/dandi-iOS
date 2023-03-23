//
//  MyPostDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

struct PostsWithPageDTO: Decodable {
    let posts: [MyPostDTO]
    let lastPage: Bool
}

struct MyPostDTO: Decodable {
    let id: Int
    let postImageUrl: String
}

extension PostsWithPageDTO {
    func toDomain() -> [MyPost] {
        return posts.map { MyPost(id: $0.id, postImageUrl: $0.postImageUrl) }
    }
}