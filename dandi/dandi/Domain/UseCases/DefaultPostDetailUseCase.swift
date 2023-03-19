//
//  DefaultPostDetailUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

final class DefaultPostDetailUseCase: PostDetailUseCase {
    let postPublisher = PublishRelay<Post?>()

    private let postRepository: PostRepository
    private let disposeBag = DisposeBag()

    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }

    func fetchPost(id: Int) {
        postRepository.fetchPost(id: id) { [weak self] result in
            switch result {
            case let .success(postDTO):
                self?.postPublisher.accept(postDTO.toDomain(id: id))
            case .failure:
                // TODO: 에러처리
                self?.postPublisher.accept(nil)
            }
        }
    }
}
