//
//  LoginReactor.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/04.
//

import AuthenticationServices
import ReactorKit
import RxSwift

final class LoginReactor: Reactor {
    let initialState: State

    private let authUseCase: AuthUseCase

    init(authUseCase: AuthUseCase) {
        self.initialState = State()
        self.authUseCase = authUseCase
    }

    struct State {
        var isLoading: Bool = false
        var isSuccessLogin: Bool?
    }

    enum Action {
        case loginButtonDidTap(fcmToken: String, idToken: String)
    }

    enum Mutation {
        case setLoginStatus(isSuccess: Bool)
        case setLoading(isLoading: Bool)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .loginButtonDidTap(fcmToken, idToken):
            authUseCase.login(fcmToken: fcmToken, idToken: idToken)
            return Observable.concat([
                Observable.just(.setLoading(isLoading: true)),
                authUseCase.loginSuccess
                    .map { Mutation.setLoginStatus(isSuccess: $0) },
                Observable.just(.setLoading(isLoading: false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setLoginStatus(isSuccess):
            newState.isSuccessLogin = isSuccess
        }
        return newState
    }
}
