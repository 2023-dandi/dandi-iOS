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
    private var page = 1

    struct State {
        var isLoading: Bool = false
        var hourlyWeathers: [TimeWeatherInfo]?
        var updateLocationSuccess: Bool = false
    }

    enum Action {
        case viewWillAppear
        case updateLocation(lon: Double, lat: Double)
    }

    enum Mutation {
        case setHourlyWeathers(weathers: [TimeWeatherInfo])
        case setLoading(isLoading: Bool)
        case setUpdateLocationSuccess(Bool)
    }

    init(hourlyWeatherUseCase: HoulryWeatherUseCase) {
        self.initialState = State()
        self.hourlyWeatherUseCase = hourlyWeatherUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return Observable.concat([
                Observable.just(.setLoading(isLoading: true)),
                hourlyWeatherUseCase.hourlyWeather
                    .map { Mutation.setHourlyWeathers(weathers: $0) },
                Observable.just(.setLoading(isLoading: false))
            ])
        case let .updateLocation(lon, lat):
            UserDefaultHandler.shared.lon = lon
            UserDefaultHandler.shared.lat = lat
            let converter: LocationConverter = .init()
            let (nx, ny): (Int, Int) = converter.convertGrid(lon: lon, lat: lat)
            hourlyWeatherUseCase.fetchWeatherInfo(nx: nx, ny: ny, page: page)
            return Observable.concat([
                Observable.just(.setLoading(isLoading: true)),
                hourlyWeatherUseCase.isCompletedUpdationLocation
                    .map { Mutation.setUpdateLocationSuccess($0) },
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
        case let .setUpdateLocationSuccess(isCompleted):
            newState.updateLocationSuccess = isCompleted
        }
        return newState
    }
}
