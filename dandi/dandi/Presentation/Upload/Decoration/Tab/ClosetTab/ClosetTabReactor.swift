//
//  ClosetTabReactor.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/02.
//

import UIKit

import ReactorKit
import RxSwift

final class ClosetTabReactor: Reactor {
    let initialState: State

    private let closetUseCase: ClosetUseCase

    struct State {
        var isLoading: Bool = false
        var clothes: [Clothes]?
        var category: [CategoryInfo]?
    }

    enum Action {
        case fetchCategory
        case fetchClothes(category: ClothesCategory, seasons: [Season])
    }

    enum Mutation {
        case setLoading(isLoading: Bool)
        case setClothesList(clothes: [Clothes])
        case setCategory(category: [CategoryInfo])
    }

    init(
        closetUseCase: ClosetUseCase
    ) {
        self.initialState = State()
        self.closetUseCase = closetUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .fetchClothes(category, seasons):
            closetUseCase.fetch(size: 500, page: 0, category: category, seasons: seasons)
            return Observable.concat([
                .just(.setLoading(isLoading: true)),
                closetUseCase.clothesPublisher.compactMap { Mutation.setClothesList(clothes: $0) },
                .just(.setLoading(isLoading: false))
            ])
        case .fetchCategory:
            return Observable.concat([
                .just(.setLoading(isLoading: true)),
                .just(.setCategory(category: [
                    CategoryInfo(category: .all, seasons: [.all, .spring, .summer, .fall, .winter]),
                    CategoryInfo(category: .bottom, seasons: [.all, .spring, .fall]),
                    CategoryInfo(category: .top, seasons: [.all, .spring, .winter]),
                    CategoryInfo(category: .bag, seasons: [.all, .spring, .fall]),
                    CategoryInfo(category: .onePiece, seasons: [.all, .winter])
                ])),
                .just(.setLoading(isLoading: false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setClothesList(clothes):
            newState.clothes = clothes
        case let .setCategory(category):
            newState.category = category
        }
        return newState
    }
}
