//
//  DetailClothesReactor.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/03.
//

import ReactorKit

final class DetailClothesReactor: Reactor {
    let initialState: State

    private let clothesUseCase: ClosetUseCase

    struct State {
        var isLoading: Bool = false
        var isDeleted: Bool?
        var clothes: DetailClothesInfo?
    }

    enum Action {
        case fetch
        case delete
    }

    enum Mutation {
        case setLoading(isLoading: Bool)
        case setClothes(clotehs: DetailClothesInfo)
        case setDeleteStatus(isDeleted: Bool)
    }

    private let id: Int

    init(
        id: Int,
        clothesUseCase: ClosetUseCase
    ) {
        self.initialState = State()
        self.id = id
        self.clothesUseCase = clothesUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetch:

            return Observable.concat([
                .just(Mutation.setLoading(isLoading: true)),
                clothesUseCase.fetch(id: id)
                    .asObservable()
                    .compactMap { $0 }
                    .map { Mutation.setClothes(clotehs: $0) },
                .just(Mutation.setLoading(isLoading: false))
            ])
        case .delete:
            clothesUseCase.delete(id: id)
            return Observable.merge([
                .just(Mutation.setLoading(isLoading: true)),
                clothesUseCase.deleteSuccessPublisher
                    .map { Mutation.setDeleteStatus(isDeleted: $0) },
                .just(Mutation.setLoading(isLoading: false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setClothes(clothes):
            newState.clothes = clothes
        case let .setDeleteStatus(isDeleted):
            newState.isDeleted = isDeleted
        }
        return newState
    }
}
