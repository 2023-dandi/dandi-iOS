//
//  DefaultUploadUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

final class DefaultUploadUseCase: UploadUseCase {
    let imagePublisher = PublishRelay<String?>()
    let postIdPublusher = PublishRelay<Int?>()

    private let postRepository: PostRepository
    private let disposeBag = DisposeBag()

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

    func uploadPost(
        imageURL: String,
        temperatures: TemperatureInfo,
        clothesFeeling: ClothesFeeling,
        weatherFeelings: [WeatherFeeling]
    ) {
        postRepository.uploadPost(
            post: PostDTO(
                postImageUrl: imageURL,
                temperatures: temperatures,
                outfitFeelings: OutfitFeelingsInfo(
                    feelingIndex: clothesFeeling.rawValue,
                    additionalFeelingIndices: weatherFeelings.map { $0.rawValue }
                )
            )
        ) { [weak self] result in
            switch result {
            case .success:
                self?.postIdPublusher.accept(11)
            case let .failure(error):
                DandiLog.error(error)
                self?.postIdPublusher.accept(nil)
            }
        }
    }
}
