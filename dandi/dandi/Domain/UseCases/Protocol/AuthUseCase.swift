//
//  AuthUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/04.
//

import RxCocoa
import RxSwift

protocol AuthUseCase {
    /// 로그인 성공
    var loginSuccess: PublishRelay<Bool> { get }

    /// 로그인
    func login(fcmToken: String, idToken: String)
}
