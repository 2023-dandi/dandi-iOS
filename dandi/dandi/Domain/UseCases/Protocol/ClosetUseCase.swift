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
    var clothesPublisher: PublishRelay<[Clothes]> { get }
    var deleteSuccessPublisher: PublishRelay<Bool> { get }

    func delete(id: Int)
    func fetch(
        size: Int,
        page: Int,
        category: String,
        seasons: [String]
    )
}
