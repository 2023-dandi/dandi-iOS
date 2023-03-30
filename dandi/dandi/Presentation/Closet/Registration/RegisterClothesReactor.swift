//
//  RegisterClothesReactor.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/30.
//

import UIKit

import ReactorKit
import RxSwift

final class RegisterClothesReactor: Reactor {
    let initialState: State

    private let clothesUseCase: RegisterClothesUseCase
    private let imageUseCase: ImageUseCase

    struct State {
        var isLoading: Bool = false
        var successUpload: Bool?
    }

    enum Action {
        case upload(category: ClothesCategory, seasons: [Season], clothesImage: UIImage)
    }

    enum Mutation {
        case setLoading(isLoading: Bool)
        case setUploadStatus(Bool)
    }

    init(
        imageUseCase: ImageUseCase,
        clothesUseCase: RegisterClothesUseCase
    ) {
        self.initialState = State()
        self.clothesUseCase = clothesUseCase
        self.imageUseCase = imageUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .upload(category, seasons, clothesImage):
            imageUseCase.uploadImage(image: clothesImage)
            return Observable.concat([
                Observable.just(.setLoading(isLoading: true)),
                imageUseCase.imagePublisher
                    .compactMap { $0 }
                    .map { [weak self] imageURL in
                        guard let self = self else { return }
                        self.clothesUseCase.upload(
                            category: category.toString,
                            seasons: seasons.map { $0.toString },
                            clothesImageURL: imageURL
                        )
                    }
                    .flatMap { self.clothesUseCase.uploadPublisher }
                    .compactMap { Mutation.setUploadStatus($0) },
                Observable.just(.setLoading(isLoading: false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setUploadStatus(isSuccess):
            newState.successUpload = isSuccess
        }
        return newState
    }
}
