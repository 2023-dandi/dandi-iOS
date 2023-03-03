//
//  AuthRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/03.
//

import RxSwift

protocol AuthRepository {
    /// 토큰 리프레시
    func refreshToken(
        accessToken: String,
        refreshToken: String
    ) -> Single<Result<VoidType, NetworkError>>

    /// 애플 로그인
    func fetchUserInfo(
        idToken: String
    ) -> Single<Result<VoidType, NetworkError>>
}
