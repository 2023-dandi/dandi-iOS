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
        imageData: Data,
        completion: @escaping NetworkCompletion<String>
    )

    func uploadPost(
        post: UploadPostContent,
        completion: @escaping NetworkCompletion<Int>
    )

    func deletePost(
        id: Int,
        completion: @escaping NetworkCompletion<StatusCase>
    )

    func like(
        id: Int,
        completion: @escaping NetworkCompletion<StatusCase>
    )

    func fetchMyPostList(completion: @escaping NetworkCompletion<ListWithPage<MyPost>>)

    func fetchPostList(
        min: Int,
        max: Int,
        size: Int,
        page: Int
    ) -> Single<NetworkResult<ListWithPage<Post>>>

    func fetchMyTemperaturePostList(
        min: Int,
        max: Int,
        size: Int,
        page: Int
    ) -> Single<NetworkResult<ListWithPage<Post>>>
}
