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

    init(interceptor _: Interceptor) {
        self.router = MoyaProvider<AuthService>(
            plugins: [NetworkLogPlugin()]
        )
    }

    func refreshToken(
        accessToken: String,
        refreshToken: String
    ) -> Single<NetworkResult<TokenDTO>> {
        return router.rx.request(.refresh(refreshToken: refreshToken, accessToken: accessToken))
            .flatMap { NetworkHandler.requestDecoded(by: $0) }
    }

    func fetchUserInfo(
        fcmToken _: String,
        idToken: String
    ) -> Single<NetworkResult<TokenDTO>> {
        return router.rx.request(.login(idToken: idToken))
            .flatMap { NetworkHandler.requestDecoded(by: $0) }
    }
}
