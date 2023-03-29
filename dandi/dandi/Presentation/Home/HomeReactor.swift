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
    private let postListUseCase: PostListUseCase
    private let postLikeUseCase: LikeUseCase
    private let temperatureUseCase: TemperatureUseCase

    struct State {
        var isLoading: Bool = false
        var hourlyWeathers: [TimeWeatherInfo] = []
        var updateLocationSuccess: Bool = false
        var posts: [Post]?
        var temperature: Temperatures?
        var likedPostID: Int?
    }

    enum Action {
        case fetchWeatherInfo
        case fetchTemperatures
        case fetchPostList(min: Int?, max: Int?)
        case like(id: Int)
    }

    enum Mutation {
        case setHourlyWeathers(weathers: [TimeWeatherInfo])
        case setLoading(isLoading: Bool)
        case setUpdateLocationSuccess(Bool)
        case setTemperature(temperature: Temperatures)
        case setPostList(posts: [Post])
        case setLikedPostID(postID: Int)
    }

    init(
        postLikeUseCase: LikeUseCase,
        hourlyWeatherUseCase: HoulryWeatherUseCase,
        postListUseCase: PostListUseCase,
        temperatureUseCase: TemperatureUseCase
    ) {
        self.initialState = State()
        self.hourlyWeatherUseCase = hourlyWeatherUseCase
        self.postListUseCase = postListUseCase
        self.temperatureUseCase = temperatureUseCase
        self.postLikeUseCase = postLikeUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        let converter: LocationConverter = .init()
        let (nx, ny): (Int, Int) = converter.convertGrid(lon: UserDefaultHandler.shared.lon, lat: UserDefaultHandler.shared.lat)

        switch action {
        case .fetchWeatherInfo:
            hourlyWeatherUseCase.fetchWeatherInfo(nx: nx, ny: ny, page: 1)
            return Observable.concat([
                Observable.just(.setLoading(isLoading: true)),
                hourlyWeatherUseCase.hourlyWeather
                    .map { Mutation.setHourlyWeathers(weathers: $0) },
                Observable.just(.setLoading(isLoading: false))
            ])
        case .fetchTemperatures:
            temperatureUseCase.fetchWeatherInfo(nx: nx, ny: ny, page: 1)
            return Observable.concat([
                Observable.just(.setLoading(isLoading: true)),
                temperatureUseCase.temperatureInfo
                    .compactMap { $0 }
                    .map { Mutation.setTemperature(temperature: $0) },
                Observable.just(.setLoading(isLoading: false))
            ])

        case let .fetchPostList(min, max):
            guard let min = min, let max = max else {
                return .empty()
            }
            return Observable.concat([
                .just(.setLoading(isLoading: true)),
                postListUseCase.fetchPostList(min: min, max: max)
                    .asObservable()
                    .map { Mutation.setPostList(posts: $0) },
                .just(.setLoading(isLoading: false))
            ])
        case let .like(id):
            postLikeUseCase.like(id: id)
            return postLikeUseCase.completionPublisher
                .compactMap { $0 }
                .filter { $0 }
                .map { _ in Mutation.setLikedPostID(postID: id) }
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
        case let .setTemperature(temperature):
            newState.temperature = temperature
        case let .setPostList(posts):
            newState.posts = posts
        case let .setLikedPostID(postID):
            newState.likedPostID = postID
        }
        return newState
    }
}
