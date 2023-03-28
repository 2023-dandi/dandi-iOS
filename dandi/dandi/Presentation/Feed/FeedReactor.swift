//
//  FeedReactor.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/28.
//

import ReactorKit
import RxSwift

final class FeedReactor: Reactor {
    let initialState: State

    private let postListUseCase: PostListUseCase
    private let postLikeUseCase: LikeUseCase
    private let temperatureUseCase: TemperatureUseCase

    struct State {
        var posts: [Post]?
        var isLoading: Bool?
        var temperature: Temperatures?
    }

    enum Action {
        case fetchTemperature
        case fetchPostList(min: Int?, max: Int?)
    }

    enum Mutation {
        case setLoading(isLoading: Bool)
        case setPostList(posts: [Post])
        case setTemperature(temperature: Temperatures)
    }

    init(
        postListUseCase: PostListUseCase,
        postLikeUseCase: LikeUseCase,
        temperatureUseCase: TemperatureUseCase
    ) {
        self.initialState = State()
        self.postListUseCase = postListUseCase
        self.postLikeUseCase = postLikeUseCase
        self.temperatureUseCase = temperatureUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchTemperature:
            let converter: LocationConverter = .init()
            let (nx, ny): (Int, Int) = converter.convertGrid(lon: UserDefaultHandler.shared.lon, lat: UserDefaultHandler.shared.lat)
            temperatureUseCase.fetchWeatherInfo(nx: nx, ny: ny, page: 1)
            return Observable.concat([
                .just(.setLoading(isLoading: true)),
                temperatureUseCase.temperatureInfo
                    .compactMap { $0 }
                    .do { self.postListUseCase.fetchPostList(min: $0.min, max: $0.max) }
                    .map { Mutation.setTemperature(temperature: $0) },
                .just(.setLoading(isLoading: false))
            ])
        case let .fetchPostList(min, max):
            guard let min = min, let max = max else {
                return .empty()
            }
            postListUseCase.fetchPostList(min: min, max: max)
            return Observable.concat([
                .just(.setLoading(isLoading: true)),
                postListUseCase.postsPublisher.map { Mutation.setPostList(posts: $0) },
                .just(.setLoading(isLoading: false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setPostList(posts):
            newState.posts = posts
        case let .setTemperature(temperature):
            newState.temperature = temperature
        }
        return newState
    }
}
