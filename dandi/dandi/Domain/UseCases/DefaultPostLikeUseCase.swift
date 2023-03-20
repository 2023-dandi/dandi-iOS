//
//  DefaultPostLikeUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/21.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

final class DefaultPostLikeUseCase: LikeUseCase {
    let completionPublisher = PublishRelay<Bool?>()

    private let postRepository: PostRepository

    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }

    func like(id: Int) {
        postRepository.like(id: id) { [weak self] result in
            switch result {
            case let .success(statusCase):
                self?.completionPublisher.accept(statusCase == .noContent)
            case .failure:
                self?.completionPublisher.accept(false)
            }
        }
    }
}
