//
//  UploadClothesImageUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/31.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

final class UploadClothesImageUseCase: ImageUseCase {
    let imagePublisher = PublishRelay<String?>()

    private let clothesRepository: ClothesRepository

    init(clothesRepository: ClothesRepository) {
        self.clothesRepository = clothesRepository
    }

    func uploadImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            imagePublisher.accept(nil)
            return
        }
        clothesRepository.uploadImage(imageData: imageData) { [weak self] result in
            switch result {
            case let .success(clothesImage):
                self?.imagePublisher.accept(clothesImage.clothesImageUrl)
            case let .failure(error):
                DandiLog.error(error)
                self?.imagePublisher.accept(nil)
            }
        }
    }
}
