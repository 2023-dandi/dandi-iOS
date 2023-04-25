//
//  ClosetUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/02.
//

import Foundation

import UIKit

import RxCocoa
import RxSwift

protocol ClosetUseCase {
    var clothesPublisher: PublishRelay<ClothesDetailInfo?> { get }
    var clothesListPublisher: PublishRelay<[Clothes]> { get }
    var deleteSuccessPublisher: PublishRelay<Bool> { get }

    func delete(id: Int)
    func fetch(id: Int) -> Single<ClothesDetailInfo?>
    func fetchCategories() -> Single<[CategoryInfo]>
    func fetchClothesList(
        size: Int,
        page: Int,
        category: ClothesCategory,
        seasons: [Season]
    )
    func fetchRecommendedClothes() -> Single<[Clothes]>
}
