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
    private let closetUseCase: ClosetUseCase

    struct State {
        var isLoading: Bool = false
        var hourlyWeathers: [TimeWeatherInfo] = []
        var updateLocationSuccess: Bool = false
        var posts: [Post]?
        var clothes: [Clothes]?
        var temperature: Temperatures?
        var likedPostID: Int?
    }

    enum Action {
        case fetchWeatherInfo
        case fetchPostList(min: Int?, max: Int?)
        case fetchClothesList
        case like(id: Int)
    }

    enum Mutation {
        case setWeathers(weathers: TodayWeatherInfo)
        case setLoading(isLoading: Bool)
        case setUpdateLocationSuccess(Bool)
        case setPostList(posts: [Post])
        case setLikedPostID(postID: Int)
        case setClothes(clothes: [Clothes])
    }

    init(
        postLikeUseCase: LikeUseCase,
        hourlyWeatherUseCase: HoulryWeatherUseCase,
        postListUseCase: PostListUseCase,
        temperatureUseCase: TemperatureUseCase,
        closetUseCase: ClosetUseCase
    ) {
        self.initialState = State()
        self.hourlyWeatherUseCase = hourlyWeatherUseCase
        self.postListUseCase = postListUseCase
        self.temperatureUseCase = temperatureUseCase
        self.postLikeUseCase = postLikeUseCase
        self.closetUseCase = closetUseCase
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
                    .map { Mutation.setWeathers(weathers: $0) },
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

        case .fetchClothesList:
            return closetUseCase.fetchRecommendedClothes()
                .asObservable()
                .map { Mutation.setClothes(clothes: $0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setWeathers(weathers):
            newState.hourlyWeathers = weathers.timeWeahtherInfos
            newState.temperature = weathers.temperatures
        case let .setUpdateLocationSuccess(isCompleted):
            newState.updateLocationSuccess = isCompleted
        case let .setPostList(posts):
            newState.posts = posts
        case let .setLikedPostID(postID):
            newState.likedPostID = postID
        case let .setClothes(clothes):
            newState.clothes = clothes
        }
        return newState
    }
}
