//
//  NicknameUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import RxCocoa
import RxSwift

protocol NicknameUseCase {
    var isNicknameUpdatedPublisher: PublishRelay<Bool?> { get }
    var nicknameValidationPublisher: PublishRelay<(text: String?, isEnabled: Bool)> { get }

    func checkValidation(nickname: String)
    func update(nickname: String)
}
