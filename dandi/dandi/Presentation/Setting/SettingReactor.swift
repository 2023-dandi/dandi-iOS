//
//  SettingReactor.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/26.
//

import ReactorKit

final class SettingReactor: Reactor {
    let initialState: State
    private let authUseCase: AuthUseCase

    struct State {
        var isSuccessLogout: Bool?
        var isSuccessWithdraw: Bool?
    }

    enum Action {
        case logout
        case withdraw
    }

    enum Mutation {
        case setLogoutStatus(isSuccess: Bool)
        case setWithdrawStatus(isSuccess: Bool)
    }

    init(authUseCase: AuthUseCase) {
        self.initialState = State()
        self.authUseCase = authUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .logout:
            return authUseCase.logout()
                .asObservable()
                .compactMap { $0 }
                .map { .setLogoutStatus(isSuccess: $0) }

        case .withdraw:
            return authUseCase.withdraw()
                .asObservable()
                .compactMap { $0 }
                .map { .setWithdrawStatus(isSuccess: $0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLogoutStatus(isSuccess):
            newState.isSuccessLogout = isSuccess
        case let .setWithdrawStatus(isSuccess):
            newState.isSuccessWithdraw = isSuccess
        }
        return newState
    }
}
