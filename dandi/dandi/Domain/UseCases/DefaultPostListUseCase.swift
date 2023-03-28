//
//  DefaultPostListUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/28.
//

import Foundation

import RxCocoa
import RxSwift

final class DefaultPostListUseCase: PostListUseCase {
    let postsPublisher = PublishRelay<[Post]>()

    private let postRepository: PostRepository

    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }

    func fetchPostList(min: Int, max: Int) {
        postRepository.fetchPostList(min: min, max: max, size: 500, page: 0) { [weak self] result in
            switch result {
            case let .success(response):
                self?.postsPublisher.accept(response.toDomain())
            case .failure:
                self?.postsPublisher.accept([])
            }
        }
    }
}
