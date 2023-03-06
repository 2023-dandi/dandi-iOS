//
//  HomeReactor.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/03.
//

import ReactorKit

final class HomeReactor: Reactor {
    let initialState: State

    private let hourlyWeatherUseCase: HoulryWeatherUseCase

    struct State {
        var isLoading: Bool = false
        var hourlyWeathers: [TimeWeatherInfo]?
    }

    enum Action {
        case viewWillAppear
    }

    enum Mutation {
        case setHourlyWeathers(weathers: [TimeWeatherInfo])
        case setLoading(isLoading: Bool)
    }

    init(hourlyWeatherUseCase: HoulryWeatherUseCase) {
        self.initialState = State()
        self.hourlyWeatherUseCase = hourlyWeatherUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            hourlyWeatherUseCase.fetchWeatherInfo()
            return Observable.concat([
                Observable.just(.setLoading(isLoading: true)),
                hourlyWeatherUseCase.hourlyWeather.map { Mutation.setHourlyWeathers(weathers: $0) },
                Observable.just(.setLoading(isLoading: false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setHourlyWeathers(weathers):
            newState.hourlyWeathers = weathers
        }
        return newState
    }
}
