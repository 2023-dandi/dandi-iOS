//
//  DefaultPostRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

import Foundation

import Moya
import RxSwift

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
        completion: @escaping NetworkCompletion<Post>
    ) {
        router.request(.getDetailPost(id: id)) { result in
            switch result {
            case let .success(response):
                let decodedResponse: NetworkResult<PostDTO> = NetworkHandler.requestDecoded(by: response)

                switch decodedResponse {
                case let .success(postDTO):
                    completion(.success(postDTO.toDomain()))

                case let .failure(error):
                    completion(.failure(error))
                }

            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func uploadImage(
        imageData: Data,
        completion: @escaping NetworkCompletion<String>
    ) {
        router.request(.postImage(imageData: imageData)) { result in
            switch result {
            case let .success(response):
                let decodedResponse: NetworkResult<PostImageDTO> = NetworkHandler.requestDecoded(by: response)

                switch decodedResponse {
                case let .success(postImageDTO):
                    completion(.success(postImageDTO.postImageUrl))

                case let .failure(error):
                    completion(.failure(error))
                }

            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func uploadPost(
        post: UploadPostContent,
        completion: @escaping NetworkCompletion<Int>
    ) {
        let temperatures = TemperaturesDTO(min: post.temperatures.min, max: post.temperatures.max)
        let outfitFeelings = OutfitFeelingsDTO(
            feelingIndex: post.clothesFeeling.rawValue,
            additionalFeelingIndices: post.weatherFeelings.map { $0.rawValue }
        )

        let postDTO = PostContentDTO(
            postImageURL: post.postImageURL,
            temperatures: temperatures,
            outfitFeelings: outfitFeelings
        )

        router.request(.postPosts(post: postDTO)) { result in
            switch result {
            case let .success(response):
                let decodedResponse: NetworkResult<PostIdDTO> = NetworkHandler.requestDecoded(by: response)

                switch decodedResponse {
                case let .success(postIdDTO):
                    let postId = postIdDTO.postId
                    completion(.success(postId))

                case let .failure(error):
                    completion(.failure(error))
                }
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

    func fetchMyPostList(completion: @escaping NetworkCompletion<MyPostsWithPage>) {
        router.request(.my) { result in
            switch result {
            case let .success(response):
                let decodedResponse: Result<MyPostsWithPageDTO, NetworkError> = NetworkHandler.requestDecoded(by: response)

                switch decodedResponse {
                case let .success(myPostsWithPageDTO):
                    completion(.success(myPostsWithPageDTO.toDomain()))

                case let .failure(error):
                    completion(.failure(error))
                }

            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func fetchPostList(
        min: Int,
        max: Int,
        size: Int,
        page: Int
    ) -> RxSwift.Single<NetworkResult<PostsWithPage>> {
        return router.rx.request(.feed(min: min, max: max, size: size, page: page))
            .map { response in
                let decodedResponse: NetworkResult<PostsWithPageDTO> = NetworkHandler.requestDecoded(by: response)

                switch decodedResponse {
                case let .success(postDTO):
                    return .success(postDTO.toDomain())

                case let .failure(error):
                    return .failure(error)
                }
            }
    }

    func fetchMyTemperaturePostList(
        min: Int,
        max: Int,
        size: Int,
        page: Int
    ) -> RxSwift.Single<NetworkResult<PostsWithPage>> {
        return router.rx.request(.myFeed(min: min, max: max, size: size, page: page))
            .map { response in
                let decodedResponse: NetworkResult<MyTemperaturePostWithPageDTO> = NetworkHandler.requestDecoded(by: response)

                switch decodedResponse {
                case let .success(postDTO):
                    return .success(postDTO.toDomain())

                case let .failure(error):
                    return .failure(error)
                }
            }
    }
}
