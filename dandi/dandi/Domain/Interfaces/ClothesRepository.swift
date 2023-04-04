//
//  ClothesRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/30.
//

import Foundation
import RxSwift

protocol ClothesRepository {
    func upload(
        category: String,
        seasons: [String],
        clothesImageURL: String,
        completion: @escaping NetworkCompletion<StatusCase>
    )

    func uploadImage(
        imageData: Data,
        completion: @escaping NetworkCompletion<String>
    )

    func delete(
        clothesID: Int,
        completion: @escaping NetworkCompletion<StatusCase>
    )

    func fetchList(
        size: Int,
        page: Int,
        category: String,
        seasons: [String],
        completion: @escaping NetworkCompletion<ListWithPage<Clothes>>
    )

    func fetchCategory() -> Single<NetworkResult<[CategoryInfo]>>
}
