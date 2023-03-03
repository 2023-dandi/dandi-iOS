//
//  DefaultAuthRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/03.
//

import Moya
import RxMoya
import RxSwift

final class DefaultAuthRepository: AuthRepository {
    let router: MoyaProvider<AuthService>

    init(interceptor: Interceptor) {
        self.router = MoyaProvider<AuthService>(
            session: Session(interceptor: interceptor),
            plugins: [NetworkLogPlugin()]
        )
    }

    func refreshToken(
        accessToken: String,
        refreshToken: String
    ) -> Single<Result<VoidType, NetworkError>> {
        return router.rx.request(.refresh(refreshToken: refreshToken, accessToken: accessToken))
            .flatMap { NetworkHandler.requestDecoded(by: $0) }
    }

    func fetchUserInfo(
        idToken: String
    ) -> Single<Result<VoidType, NetworkError>> {
        return router.rx.request(.login(idToken: idToken))
            .flatMap { NetworkHandler.requestDecoded(by: $0) }
    }
}
