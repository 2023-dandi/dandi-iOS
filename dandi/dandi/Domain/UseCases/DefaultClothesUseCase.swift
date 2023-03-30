//
//  DefaultClothesUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/31.
//

import Foundation

import RxCocoa
import RxSwift

final class DefaultClothesUseCase: ClothesUseCase {
    let deleteSuccessPublisher = PublishRelay<Bool>()

    private let clothesRepository: ClothesRepository

    init(clothesRepository: ClothesRepository) {
        self.clothesRepository = clothesRepository
    }

    func delete(id: Int) {
        clothesRepository.delete(clothesID: id) { [weak self] result in
            switch result {
            case let .success(statusCase):
                self?.deleteSuccessPublisher.accept(statusCase == .noContent)
            case .failure:
                self?.deleteSuccessPublisher.accept(false)
            }
        }
    }
}
