//
//  DefaultMyPostsUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

final class DefaultMyPostsUseCase: MyPostListUseCase {
    let postsPublisher = PublishRelay<[MyPost]>()

    private let postRepository: PostRepository

    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }

    func fetchPostList() {
        postRepository.fetchMyPostList { [weak self] result in
            switch result {
            case let .success(response):
                self?.postsPublisher.accept(response.list)
            case .failure:
                self?.postsPublisher.accept([])
            }
        }
    }
}
