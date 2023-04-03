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
        guard let imageData = image.pngData() else {
            imagePublisher.accept(nil)
            return
        }

        var compressedPngImageData: Data?

        if let source = CGImageSourceCreateWithData(imageData as CFData, nil) {
            let maxDimension: CGFloat = 1024
            let options = [
                kCGImageSourceThumbnailMaxPixelSize: maxDimension,
                kCGImageSourceCreateThumbnailFromImageAlways: true
            ] as CFDictionary

            if let thumbnail = CGImageSourceCreateThumbnailAtIndex(source, 0, options) {
                compressedPngImageData = UIImage(cgImage: thumbnail).pngData()
            }
        }

        guard let compressedData = compressedPngImageData else {
            imagePublisher.accept(nil)
            return
        }

        clothesRepository.uploadImage(imageData: compressedData) { [weak self] result in
            switch result {
            case let .success(clothesImageUrl):
                self?.imagePublisher.accept(clothesImageUrl)
            case let .failure(error):
                DandiLog.error(error)
                self?.imagePublisher.accept(nil)
            }
        }
    }
}
