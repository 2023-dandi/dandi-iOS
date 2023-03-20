//
//  MyInformationReactor.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import Foundation
import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class MyInformationReactor: Reactor {
    let initialState: State

    private let nicknameUseCase: NicknameUseCase
    private let imageUseCase: ImageUseCase

    struct State {
        var profile: UserProfile
        var isValidNickname: Bool?
        var helperText: String?
        var isUpdateCompleted: Bool?
    }

    enum Action {
        case checkNicknameValidation(nickname: String)
        case update(nickname: String?, image: UIImage?)
    }

    enum Mutation {
        case setUserProfile(UserProfile)
        case setValidation(String?, Bool)
        case setCompletion(Bool?)
    }

    init(
        userProfile: UserProfile,
        nicknameUseCase: NicknameUseCase,
        imageUseCase: ImageUseCase
    ) {
        self.initialState = State(profile: userProfile)
        self.nicknameUseCase = nicknameUseCase
        self.imageUseCase = imageUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .checkNicknameValidation(nickname):
            nicknameUseCase.checkValidation(nickname: nickname)
            return nicknameUseCase.nicknameValidationPublisher
                .map { Mutation.setValidation($0.text, $0.isEnabled) }
        case let .update(nickname, image):

            let nicknameUploaded = nicknameUseCase.isNicknameUpdatedPublisher
                .compactMap { $0 }
                .map { Mutation.setCompletion($0) }

            let imageUploaded = imageUseCase.imagePublisher
                .compactMap { $0 }
                .map { _ in Mutation.setCompletion(true) }

            if let nickname, let image {
                nicknameUseCase.update(nickname: nickname)
                imageUseCase.uploadImage(image: image)
                return Observable.concat([
                    nicknameUploaded,
                    imageUploaded
                ])
            }

            if let nickname {
                nicknameUseCase.update(nickname: nickname)
                return nicknameUploaded
            }

            if let image {
                imageUseCase.uploadImage(image: image)
                return imageUploaded
            }

            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setUserProfile(userProfile):
            newState.profile = userProfile
        case let .setValidation(text, isValid):
            newState.isValidNickname = isValid
            newState.helperText = text
        case let .setCompletion(isCompleted):
            newState.isUpdateCompleted = isCompleted
        }
        return newState
    }
}
