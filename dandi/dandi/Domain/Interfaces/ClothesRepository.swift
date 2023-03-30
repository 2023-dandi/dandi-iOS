//
//  ClothesRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/30.
//

import UIKit

protocol ClothesRepository {
    func upload(
        category: String,
        seasons: [String],
        clothesImageURL: String,
        completion: @escaping NetworkCompletion<StatusCase>
    )

    func uploadImage(
        imageData: Data,
        completion: @escaping NetworkCompletion<ClothesImageDTO>
    )

    func delete(
        clothesID: Int,
        completion: @escaping NetworkCompletion<StatusCase>
    )
}
