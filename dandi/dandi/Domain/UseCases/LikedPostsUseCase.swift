//
//  LikedPostsUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/26.
//

import Foundation

import RxCocoa
import RxSwift

final class LikedPostsUseCase: PostListUseCase {
    private let postRepository: PostRepository

    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }

    func fetchPostList(min _: Int?, max _: Int?) -> Single<[Post]> {
        return postRepository.fetchLikedPost(size: 500, page: 1)
            .map { result in
                switch result {
                case let .success(listWithPage):
                    return listWithPage.list
                case .failure:
                    return []
                }
            }
    }
}
