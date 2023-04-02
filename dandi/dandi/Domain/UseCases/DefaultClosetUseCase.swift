//
//  DefaultClosetUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/02.
//

import Foundation

import RxCocoa
import RxSwift

final class DefaultClosetUseCase: ClosetUseCase {
    let clothesPublisher = PublishRelay<[Clothes]>()

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

    func fetch(
        size: Int,
        page: Int,
        category: String,
        seasons: [String]
    ) {
        clothesRepository.fetchList(
            size: size,
            page: page,
            category: category,
            seasons: seasons
        ) { [weak self] result in
            switch result {
            case let .success(clothesWithPage):
                self?.clothesPublisher.accept(clothesWithPage.list)
            case .failure:
                self?.clothesPublisher.accept([])
            }
        }
    }
}
