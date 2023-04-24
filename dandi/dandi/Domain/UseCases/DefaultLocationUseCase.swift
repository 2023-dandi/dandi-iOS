//
//  DefaultLocationUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/24.
//

import Foundation
import RxCocoa
import RxSwift

final class DefaultLocationUseCase: LocationUseCase {
    let completionPublisher = PublishRelay<Bool?>()

    private let memberRepository: MemberRepository

    init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
    }

    func saveLocation(
        latitude: Double,
        longitude: Double,
        address: String
    ) {
        memberRepository.updateLocation(
            latitude: latitude,
            longitude: longitude
        ) { [weak self] result in
            switch result {
            case let .success(statusCase):
                self?.completionPublisher.accept(statusCase == .noContent)
                if statusCase == .noContent {
                    UserDefaultHandler.shared.lat = latitude
                    UserDefaultHandler.shared.lon = longitude
                    UserDefaultHandler.shared.address = address
                }
            case .failure:
                self?.completionPublisher.accept(false)
            }
        }
    }
}
