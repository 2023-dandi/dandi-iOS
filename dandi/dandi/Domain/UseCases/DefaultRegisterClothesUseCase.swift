//
//  DefaultRegisterClothesUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/30.
//

import Foundation

import RxCocoa
import RxSwift

final class DefaultRegisterClothesUseCase: RegisterClothesUseCase {
    let uploadPublisher = PublishRelay<Bool>()

    private let clothesRepository: ClothesRepository

    init(clothesRepository: ClothesRepository) {
        self.clothesRepository = clothesRepository
    }

    func upload(category: String, seasons: [String], clothesImageURL: String) {
        clothesRepository.upload(
            category: category,
            seasons: seasons,
            clothesImageURL: clothesImageURL
        ) { [weak self] result in
            switch result {
            case let .success(statusCase):
                self?.uploadPublisher.accept(statusCase == .created)
            case .failure:
                self?.uploadPublisher.accept(false)
            }
        }
    }
}
