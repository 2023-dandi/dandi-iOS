//
//  DefaultUploadPostUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

final class DefaultUploadPostUseCase: UploadPostUseCase {
    let postIdPublusher = PublishRelay<Int?>()

    private let postRepository: PostRepository

    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }

    func uploadPost(
        imageURL: String,
        temperatures: Temperatures,
        clothesFeeling: ClothesFeeling,
        weatherFeelings: [WeatherFeeling]
    ) {
        postRepository.uploadPost(
            post: UploadPostContent(
                postImageURL: imageURL,
                clothesFeeling: clothesFeeling,
                weatherFeelings: weatherFeelings,
                temperatures: temperatures
            )
        ) { [weak self] result in
            switch result {
            case let .success(postId):
                self?.postIdPublusher.accept(postId)
            case let .failure(error):
                DandiLog.error(error)
                self?.postIdPublusher.accept(nil)
            }
        }
    }
}
