//
//  UploadPostImageUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/30.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

final class UploadPostImageUseCase: ImageUseCase {
    let imagePublisher = PublishRelay<String?>()

    private let postRepository: PostRepository

    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }

    func uploadImage(image: UIImage) {
        postRepository.uploadImage(image: image) { [weak self] result in
            switch result {
            case let .success(postImage):
                self?.imagePublisher.accept(postImage.postImageUrl)
            case let .failure(error):
                DandiLog.error(error)
                self?.imagePublisher.accept(nil)
            }
        }
    }
}
