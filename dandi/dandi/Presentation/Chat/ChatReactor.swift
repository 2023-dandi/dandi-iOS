//
//  ChatReactor.swift
//  dandi
//
//  Created by 김윤서 on 2023/05/14.
//

import ReactorKit

final class ChatReactor: Reactor {
    let initialState: State

    private let chatUseCase: ChatUseCase

    struct State {
        var content: String?
    }

    enum Action {
        case chat(content: String)
    }

    enum Mutation {
        case setContent(content: String?)
    }

    init(chatUseCase: ChatUseCase) {
        self.initialState = State()
        self.chatUseCase = chatUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .chat(content):
            return chatUseCase.chat(content: content)
                .map { Mutation.setContent(content: $0?.message) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setContent(content):
            newState.content = content
        }
        return newState
    }
}
