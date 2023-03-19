//
//  PostDetailReactor.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import ReactorKit
import RxSwift

final class PostDetailReactor: Reactor {
    let initialState: State

    private let postDetailUseCase: PostDetailUseCase

    struct State {
        var isLoading: Bool = false
        var post: Post?
    }

    enum Action {
        case fetchPostDetail(id: Int)
    }

    enum Mutation {
        case setLoading(isLoading: Bool)
        case setPost(Post)
    }

    init(
        postDetailUseCase: PostDetailUseCase
    ) {
        self.initialState = State()
        self.postDetailUseCase = postDetailUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .fetchPostDetail(id):
            postDetailUseCase.fetchPost(id: id)
            return postDetailUseCase.postPublisher
                .compactMap { $0 }
                .map { Mutation.setPost($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setPost(post):
            newState.post = post
        }
        return newState
    }
}
