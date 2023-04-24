//
//  LocationUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/24.
//

import Foundation

import RxRelay
import RxSwift

protocol LocationUseCase {
    var completionPublisher: PublishRelay<Bool?> { get }
    func saveLocation(
        latitude: Double,
        longitude: Double,
        address: String
    )
}
