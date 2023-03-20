//
//  DefaultPostRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

import Moya
import RxMoya
import RxSwift
import UIKit

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
        completion: @escaping NetworkCompletion<PostDTO>
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
        post: PostDTO,
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
}
