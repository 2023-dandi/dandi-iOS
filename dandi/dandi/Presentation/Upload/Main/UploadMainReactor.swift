//
//  UploadMainReactor.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

import UIKit

import ReactorKit
import RxSwift

final class UploadMainReactor: Reactor {
    let initialState: State

    private let weatherUseCase: TemperatureUseCase
    private let uploadUseCase: UploadPostUseCase
    private let imageUseCase: ImageUseCase

    struct State {
        var isLoading: Bool?
        var temparature: Temperatures = .init(min: 0, max: 0)
        var postID: Int?
    }

    enum Action {
        case viewWillAppear
        case upload(
            image: UIImage,
            clothesFeeling: ClothesFeeling?,
            weatherFeelings: [WeatherFeeling]
        )
    }

    enum Mutation {
        case setLoading(isLoading: Bool)
        case setTemparature(Temperatures)
        case setPostID(Int?)
    }

    init(
        weatherUseCase: TemperatureUseCase,
        uploadUseCase: UploadPostUseCase,
        imageUseCase: UploadPostImageUseCase
    ) {
        self.initialState = State()
        self.weatherUseCase = weatherUseCase
        self.uploadUseCase = uploadUseCase
        self.imageUseCase = imageUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let converter: LocationConverter = .init()
            let (nx, ny): (Int, Int) = converter.convertGrid(
                lon: UserDefaultHandler.shared.lon,
                lat: UserDefaultHandler.shared.lat
            )
            weatherUseCase.fetchWeatherInfo(nx: nx, ny: ny, page: 1)
            return weatherUseCase.temperatureInfo
                .compactMap { $0 }
                .map { Mutation.setTemparature($0) }
        case let .upload(image, clothesFeeling, weatherFeelings):
            imageUseCase.uploadImage(image: image)
            return Observable.concat([
                Observable.just(.setLoading(isLoading: true)),
                imageUseCase.imagePublisher
                    .compactMap { $0 }
                    .map { [weak self] imageURL in
                        guard
                            let self = self,
                            let clothesFeeling = clothesFeeling
                        else { return }

                        self.uploadUseCase.uploadPost(
                            imageURL: imageURL,
                            temperatures: self.currentState.temparature,
                            clothesFeeling: clothesFeeling,
                            weatherFeelings: Array(Set(weatherFeelings))
                        )
                    }
                    .flatMap { self.uploadUseCase.postIdPublusher }
                    .compactMap { Mutation.setPostID($0) },
                Observable.just(.setLoading(isLoading: false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setTemparature(temperatureInfo):
            newState.temparature = temperatureInfo
        case let .setPostID(id):
            newState.postID = id
        }
        return newState
    }
}
