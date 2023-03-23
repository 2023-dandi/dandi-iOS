//
//  PostRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

import UIKit

protocol PostRepository {
    func fetchPost(
        id: Int,
        completion: @escaping NetworkCompletion<PostDTO>
    )

    func uploadImage(
        image: UIImage,
        completion: @escaping NetworkCompletion<PostImageDTO>
    )

    func uploadPost(
        post: PostDTO,
        completion: @escaping NetworkCompletion<PostIdDTO>
    )

    func deletePost(
        id: Int,
        completion: @escaping NetworkCompletion<StatusCase>
    )

    func like(
        id: Int,
        completion: @escaping NetworkCompletion<StatusCase>
    )

    func fetchMyPostList(completion: @escaping NetworkCompletion<PostsWithPageDTO>)
}
