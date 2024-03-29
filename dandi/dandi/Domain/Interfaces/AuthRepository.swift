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
    ) -> Single<NetworkResult<Token>>

    /// 애플 로그인
    func fetchUserInfo(
        fcmToken: String,
        idToken: String
    ) -> Single<NetworkResult<Token>>

    /// 로그아웃
    func logout() -> Single<NetworkResult<StatusCase>>

    /// 탈퇴
    func withdraw() -> Single<NetworkResult<StatusCase>>
}
