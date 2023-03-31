//
//  PostRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

import RxSwift
import UIKit.UIImage

protocol PostRepository {
    func fetchPost(
        id: Int,
        completion: @escaping NetworkCompletion<Post>
    )

    func uploadImage(
        image: UIImage,
        completion: @escaping NetworkCompletion<String>
    )

    func uploadPost(
        post: PostContentDTO,
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

    func fetchMyPostList(completion: @escaping NetworkCompletion<MyPostsWithPageDTO>)

    func fetchPostList(
        min: Int,
        max: Int,
        size: Int,
        page: Int
    ) -> Single<NetworkResult<PostsWithPageDTO>>

    func fetchMyTemperaturePostList(
        min: Int,
        max: Int,
        size: Int,
        page: Int
    ) -> Single<NetworkResult<MyTemperaturePostWithPageDTO>>
}
