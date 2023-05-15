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
    ) -> Single<NetworkResult<Token>> {
        return router.rx.request(.refresh(refreshToken: refreshToken, accessToken: accessToken))
            .map { response in
                let decodedResponse: NetworkResult<TokenDTO> = NetworkHandler.requestDecoded(by: response)
                switch decodedResponse {
                case let .success(tokenDTO):
                    return .success(tokenDTO.toDomain())

                case let .failure(error):
                    return .failure(error)
                }
            }
    }

    func fetchUserInfo(
        fcmToken: String,
        idToken: String
    ) -> Single<NetworkResult<Token>> {
        return router.rx.request(.login(idToken: idToken, fcmToken: fcmToken))
            .map { response in
                let decodedResponse: NetworkResult<TokenDTO> = NetworkHandler.requestDecoded(by: response)
                switch decodedResponse {
                case let .success(tokenDTO):
                    return .success(tokenDTO.toDomain())

                case let .failure(error):
                    return .failure(error)
                }
            }
    }

    func logout() -> RxSwift.Single<NetworkResult<StatusCase>> {
        return router.rx.request(.logout)
            .map { response in
                dump(response)
                let decodedResponse: NetworkResult<StatusCase> = NetworkHandler.requestStatusCaseDecoded(by: response)

                switch decodedResponse {
                case let .success(statusCase):
                    return .success(statusCase)

                case let .failure(error):
                    return .failure(error)
                }
            }
    }

    func withdraw() -> RxSwift.Single<NetworkResult<StatusCase>> {
        return router.rx.request(.witdraw)
            .map { response in
                let decodedResponse: NetworkResult<StatusCase> = NetworkHandler.requestStatusCaseDecoded(by: response)

                switch decodedResponse {
                case let .success(statusCase):
                    return .success(statusCase)

                case let .failure(error):
                    return .failure(error)
                }
            }
    }
}
