//
//  RegisterClothesUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/30.
//

import Foundation

import UIKit

import RxCocoa
import RxSwift

protocol RegisterClothesUseCase {
    var uploadPublisher: PublishRelay<Bool> { get }
    var deleteSuccessPublisher: PublishRelay<Bool> { get }

    func upload(
        category: String,
        seasons: [String],
        clothesImageURL: String
    )

    func delete(id: Int)
}
