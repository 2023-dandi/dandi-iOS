////
////  PostDetailReactor.swift
////  dandi
////
////  Created by 김윤서 on 2023/03/20.
////
//
// import ReactorKit
// import RxSwift
//
// final class PostDetailReactor: Reactor {
////    let initialState: State
////
////    private let weatherUseCase: TemperatureUseCase
////    private let uploadUseCase: UploadUseCase
////
////    struct State {
////        var isLoading: Bool = false
////        var post: Post?
////    }
////
////    enum Action {
////        case viewWillAppear
////    }
////
////    enum Mutation {
////        case setLoading(isLoading: Bool)
////        case setPost(Post)
////    }
////
////    init(
////        uploadUseCase: UploadUseCase
////    ) {
////        self.initialState = State()
////        self.weatherUseCase = weatherUseCase
////        self.uploadUseCase = uploadUseCase
////    }
////
////    func mutate(action: Action) -> Observable<Mutation> {
////        switch action {
////        case .viewWillAppear:
////            let converter: LocationConverter = .init()
////            let (nx, ny): (Int, Int) = converter.convertGrid(
////                lon: UserDefaultHandler.shared.lon,
////                lat: UserDefaultHandler.shared.lat
////            )
////            weatherUseCase.fetchWeatherInfo(nx: nx, ny: ny, page: 1)
////            return weatherUseCase.temperatureInfo
////                .compactMap { $0 }
////                .map { Mutation.setTemparature($0) }
////       ==
////            ])
////        }
////    }
////
////    func reduce(state: State, mutation: Mutation) -> State {
////        var newState = state
////        switch mutation {
////        case let .setLoading(isLoading):
////
////        }
////        return newState
////    }
// }
