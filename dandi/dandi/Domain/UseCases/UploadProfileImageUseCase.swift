//
//  UploadProfileImageUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

final class UploadProfileImageUseCase: ImageUseCase {
    let imagePublisher = PublishRelay<String?>()

    private let memberRepository: MemberRepository

    init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
    }

    func uploadImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: .leastNormalMagnitude) else {
            return imagePublisher.accept(nil)
        }
        memberRepository.updateProfileImage(imageData: imageData) { [weak self] result in
            switch result {
            case let .success(profileImageUrl):
                self?.imagePublisher.accept(profileImageUrl)
            case let .failure(error):
                DandiLog.error(error)
                self?.imagePublisher.accept(nil)
            }
        }
    }
}
