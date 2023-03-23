//
//  DefaultMemberInfoUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

final class DefaultMemberInfoUseCase: MemberInfoUseCase {
    let memberInfoPublisher = PublishRelay<UserProfile?>()

    private let memberRepository: MemberRepository
    private let converter: LocationConverter
    private let disposeBag = DisposeBag()

    init(
        memberRepository: MemberRepository,
        converter: LocationConverter
    ) {
        self.converter = converter
        self.memberRepository = memberRepository
    }

    func fetchUserInfo() {
        memberRepository.fetchMemberInfo { [weak self] result in
            switch result {
            case let .success(memberInfoDTO):
                self?.memberInfoPublisher.accept(memberInfoDTO.toDomain(location: ""))
                self?.converter.fetchAddress(
                    latitude: UserDefaultHandler.shared.lat,
                    longitude: UserDefaultHandler.shared.lon
                ) { address in
                    self?.memberInfoPublisher.accept(memberInfoDTO.toDomain(location: address))
                }
            case .failure:
                self?.memberInfoPublisher.accept(nil)
            }
        }
    }
}
