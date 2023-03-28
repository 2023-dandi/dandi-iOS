//
//  DefaultPostRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

import UIKit

import Moya

final class DefaultPostRepository: PostRepository {
    let router: MoyaProvider<PostService>

    init(interceptor: Interceptor) {
        self.router = MoyaProvider<PostService>(
            session: Session(interceptor: interceptor),
            plugins: [NetworkLogPlugin()]
        )
    }

    func fetchPost(
        id: Int,
        completion: @escaping NetworkCompletion<PostContentDTO>
    ) {
        router.request(.getDetailPost(id: id)) { result in
            switch result {
            case let .success(response):
                completion(NetworkHandler.requestDecoded(by: response))
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func uploadImage(
        image: UIImage,
        completion: @escaping NetworkCompletion<PostImageDTO>
    ) {
        router.request(.postImage(image: image)) { result in
            switch result {
            case let .success(response):
                completion(NetworkHandler.requestDecoded(by: response))
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func uploadPost(
        post: PostContentDTO,
        completion: @escaping NetworkCompletion<PostIdDTO>
    ) {
        router.request(.postPosts(post: post)) { result in
            switch result {
            case let .success(response):
                completion(NetworkHandler.requestDecoded(by: response))
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func deletePost(
        id: Int,
        completion: @escaping NetworkCompletion<StatusCase>
    ) {
        router.request(.deletePost(id: id)) { result in
            switch result {
            case let .success(response):
                completion(NetworkHandler.requestStatusCaseDecoded(by: response))
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func like(
        id: Int,
        completion: @escaping NetworkCompletion<StatusCase>
    ) {
        router.request(.like(id: id)) { result in
            switch result {
            case let .success(response):
                completion(NetworkHandler.requestStatusCaseDecoded(by: response))
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func fetchMyPostList(completion: @escaping NetworkCompletion<MyPostsWithPageDTO>) {
        router.request(.my) { result in
            switch result {
            case let .success(response):
                completion(NetworkHandler.requestDecoded(by: response))
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func fetchPostList(
        min: Int,
        max: Int,
        size: Int,
        page: Int,
        completion: @escaping NetworkCompletion<PostsWithPageDTO>
    ) {
        router.request(.feed(min: min, max: max, size: size, page: page)) { result in
            switch result {
            case let .success(response):
                completion(NetworkHandler.requestDecoded(by: response))
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }
}
