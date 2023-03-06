//
//  DefaultAuthUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/04.
//

import RxCocoa
import RxSwift

final class DefaultAuthUseCase: AuthUseCase {
    let loginSuccess = PublishRelay<Bool>()

    private let authRepository: AuthRepository
    private let disposeBag = DisposeBag()

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func login(fcmToken: String, idToken: String) {
        authRepository.fetchUserInfo(fcmToken: fcmToken, idToken: idToken)
            .subscribe { [weak self] result in
                switch result {
                case let .success(response):
                    KeychainHandler.shared.accessToken = response.accessToken
                    KeychainHandler.shared.refreshToken = response.refreshToken
                    self?.loginSuccess.accept(true)
                case .failure:
                    self?.loginSuccess.accept(false)
                }
            }
            .disposed(by: disposeBag)
    }
}