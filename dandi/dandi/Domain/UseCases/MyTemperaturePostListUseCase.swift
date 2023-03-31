//
//  MyTemperaturePostListUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/29.
//

import Foundation

import RxCocoa
import RxSwift

final class MyTemperaturePostListUseCase: PostListUseCase {
    private let postRepository: PostRepository

    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }

    func fetchPostList(min: Int?, max: Int?) -> Single<[Post]> {
        guard let min = min, let max = max else { return .error(NetworkError.decodedError) }
        return postRepository.fetchMyTemperaturePostList(min: min, max: max, size: 500, page: 0)
            .map { result in
                switch result {
                case let .success(response):
                    return response.posts
                case .failure:
                    return []
                }
            }
    }
}
