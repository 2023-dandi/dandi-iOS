//
//  MyPageReactor.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import ReactorKit
import RxCocoa
import RxSwift

final class MyPageReactor: Reactor {
    let initialState: State

    private let memberInfoUseCase: MemberInfoUseCase

    struct State {
        var isLoading: Bool = false
        var profile: UserProfile?
    }

    enum Action {
        case fetchProfile
    }

    enum Mutation {
        case setUserProfile(UserProfile)
    }

    init(memberInfoUseCase: MemberInfoUseCase) {
        self.initialState = State()
        self.memberInfoUseCase = memberInfoUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchProfile:
            memberInfoUseCase.fetchUserInfo()
            return memberInfoUseCase.memberInfoPublisher
                .compactMap { $0 }
                .compactMap { Mutation.setUserProfile($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setUserProfile(userProfile):
            newState.profile = userProfile
        }
        return newState
    }
}
