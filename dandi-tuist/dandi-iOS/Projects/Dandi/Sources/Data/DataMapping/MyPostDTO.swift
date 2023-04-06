//
//  MyPostDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

struct MyPostsWithPageDTO: Decodable {
    let posts: [MyPostDTO]
    let lastPage: Bool
}

struct MyPostDTO: Decodable {
    let id: Int
    let postImageUrl: String
}

extension MyPostsWithPageDTO {
    func toDomain() -> ListWithPage<MyPost> {
        let posts = posts.map { MyPost(id: $0.id, postImageUrl: $0.postImageUrl) }
        return ListWithPage<MyPost>(list: posts, lastPage: lastPage)
    }
}
