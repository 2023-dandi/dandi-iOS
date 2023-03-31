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
        guard let imageData = image.jpegData(compressionQuality: .greatestFiniteMagnitude) else {
            imagePublisher.accept(nil)
            return
        }
        postRepository.uploadImage(imageData: imageData) { [weak self] result in
            switch result {
            case let .success(postImageURL):
                self?.imagePublisher.accept(postImageURL)
            case let .failure(error):
                DandiLog.error(error)
                self?.imagePublisher.accept(nil)
            }
        }
    }
}
