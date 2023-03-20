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
    private let postLikeUseCase: LikeUseCase

    struct State {
        var isLiked: Bool?
        var isLoading: Bool = false
        var post: Post?
    }

    enum Action {
        case fetchPostDetail(id: Int)
        case like(id: Int)
    }

    enum Mutation {
        case setLoading(isLoading: Bool)
        case setPost(Post)
        case setLikeButtonStatus(isLiked: Bool)
    }

    init(
        postDetailUseCase: PostDetailUseCase,
        postLikeUseCase: LikeUseCase
    ) {
        self.initialState = State()
        self.postDetailUseCase = postDetailUseCase
        self.postLikeUseCase = postLikeUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .fetchPostDetail(id):
            postDetailUseCase.fetchPost(id: id)
            return postDetailUseCase.postPublisher
                .compactMap { $0 }
                .map { Mutation.setPost($0) }
        case let .like(id):
            postLikeUseCase.like(id: id)
            return postLikeUseCase.completionPublisher
                .compactMap { $0 }
                .map { Mutation.setLikeButtonStatus(isLiked: $0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setPost(post):
            newState.post = post
        case let .setLikeButtonStatus(isLiked):
            newState.isLiked = isLiked
        }
        return newState
    }
}
