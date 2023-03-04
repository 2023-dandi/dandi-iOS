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
    ) -> NetworkResult<TokenDTO>

    /// 애플 로그인
    func fetchUserInfo(
        fcmToken: String,
        idToken: String
    ) -> NetworkResult<TokenDTO>
}
