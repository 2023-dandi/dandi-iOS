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
                    dump(response)
                    UserDefaultHandler.shared.accessToken = response.accessToken
                    UserDefaultHandler.shared.refreshToken = response.refreshToken
                    self?.loginSuccess.accept(true)
                case .failure:
                    self?.loginSuccess.accept(false)
                }
            }
            .disposed(by: disposeBag)
    }

    func logout() -> Single<Bool?> {
        return authRepository.logout()
            .map { result in
                switch result {
                case let .success(statusCase):
                    return statusCase == .noContent

                case .failure:
                    return false
                }
            }
    }

    func withdraw() -> Single<Bool?> {
        return authRepository.withdraw()
            .map { result in
                switch result {
                case let .success(statusCase):
                    return statusCase == .noContent

                case .failure:
                    return false
                }
            }
    }
}
