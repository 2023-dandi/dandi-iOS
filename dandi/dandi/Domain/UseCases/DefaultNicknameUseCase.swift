//
//  DefaultNicknameUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

final class DefaultNicknameUseCase: NicknameUseCase {
    let isNicknameUpdatedPublisher = PublishRelay<Bool?>()
    let nicknameValidationPublisher = PublishRelay<(text: String?, isEnabled: Bool)>()

    private let memberRepository: MemberRepository
    private let disposeBag = DisposeBag()

    init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
    }

    func checkValidation(nickname: String) {
        if isValid(nickname), nickname.count <= 25, nickname.count >= 8 {
            memberRepository.confirmNicknameDuplication(nickname: nickname) { [weak self] result in
                switch result {
                case let .success(duplicated):
                    if duplicated {
                        self?.nicknameValidationPublisher.accept(("이미 사용 중인 아이디입니다.", false))
                        return
                    }
                    self?.nicknameValidationPublisher.accept(("사용 가능한 아이디입니다.", true))
                case .failure:
                    break
                }
            }
            return
        }
        if !isValid(nickname) {
            nicknameValidationPublisher.accept(("영문자, 숫자, 밑줄 및 마침표만 가능합니다", false))
            return
        }
        nicknameValidationPublisher.accept(("아이디는 8자 이상 25자 이하이여야 합니다", false))
    }

    func update(nickname: String) {
        guard isValid(nickname) else {
            isNicknameUpdatedPublisher.accept(false)
            return
        }

        memberRepository.updateNickname(nickname: nickname) { [weak self] result in
            switch result {
            case .success:
                self?.isNicknameUpdatedPublisher.accept(true)
            case .failure:
                self?.isNicknameUpdatedPublisher.accept(false)
            }
        }
    }
}

extension DefaultNicknameUseCase {
    private func isValid(_ nickname: String) -> Bool {
        let pattern = "^[A-Za-z0-9._]+$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(
            in: nickname,
            options: [],
            range: NSRange(location: 0, length: nickname.count)
        ) {
            return true
        }
        return false
    }
}
