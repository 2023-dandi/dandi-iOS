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

protocol UploadUseCase {
    var imagePublisher: PublishRelay<String?> { get }
    var postSuccessPublusher: PublishRelay<Bool> { get }
    func uploadImage(image: UIImage)
    func uploadPost(
        imageURL: String,
        temperatures: TemperatureInfo,
        clothesFeeling: ClothesFeeling,
        weatherFeelings: [WeatherFeeling]
    )
}

final class DefaultUploadUseCase: UploadUseCase {
    let imagePublisher = PublishRelay<String?>()
    let postSuccessPublusher = PublishRelay<Bool>()

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
                self?.postSuccessPublusher.accept(true)
            case let .failure(error):
                DandiLog.error(error)
                self?.postSuccessPublusher.accept(false)
            }
        }
    }
}
