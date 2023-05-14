//
//  ConfirmLocationReactor.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/24.
//

import ReactorKit

final class ConfirmLocationReactor: Reactor {
    let initialState: State
    private let locationUseCase: LocationUseCase

    struct State {
        var isSuccessChangeLocation: Bool?
    }

    enum Action {
        case setLoaction(lat: Double, lon: Double, address: String)
    }

    enum Mutation {
        case setChangeLocationStatus(isSuccess: Bool)
    }

    init(locationUseCase: LocationUseCase) {
        self.initialState = State()
        self.locationUseCase = locationUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setLoaction(lat, lon, address):
            UserDefaultHandler.shared.lat = lat
            UserDefaultHandler.shared.lon = lon
            UserDefaultHandler.shared.address = address
            UserDefaultHandler.shared.max = -1000
            UserDefaultHandler.shared.min = -1000
            locationUseCase.saveLocation(latitude: lat, longitude: lon, address: address)
            return locationUseCase.completionPublisher
                .compactMap { $0 }
                .map { .setChangeLocationStatus(isSuccess: $0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setChangeLocationStatus(isSuccess):
            newState.isSuccessChangeLocation = isSuccess
        }
        return newState
    }
}
