//
//  DefaultImageUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

final class DefaultProfileImageUseCase: ImageUseCase {
    let imagePublisher = PublishRelay<String?>()

    private let memberRepository: MemberRepository

    init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
    }

    func uploadImage(image: UIImage) {
        memberRepository.updateProfileImage(image: image) { [weak self] result in
            switch result {
            case let .success(profileImage):
                self?.imagePublisher.accept(profileImage.profileImageUrl)
            case let .failure(error):
                DandiLog.error(error)
                self?.imagePublisher.accept(nil)
            }
        }
    }
}
