//
//  LikeHistoryReactor.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/26.
//

import ReactorKit

final class LikeHistoryReactor: Reactor {
    let initialState: State

    private let postListUseCase: PostListUseCase
    private let postLikeUseCase: LikeUseCase

    struct State {
        var posts: [Post]?
        var isLoading: Bool?
        var likedPostID: Int?
    }

    enum Action {
        case fetchPostList
        case like(id: Int)
    }

    enum Mutation {
        case setLoading(isLoading: Bool)
        case setPostList(posts: [Post])
        case setLikeButtonStatus(postID: Int)
    }

    init(
        postListUseCase: PostListUseCase,
        postLikeUseCase: LikeUseCase
    ) {
        self.initialState = State()
        self.postListUseCase = postListUseCase
        self.postLikeUseCase = postLikeUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchPostList:
            return Observable.concat([
                .just(.setLoading(isLoading: true)),
                postListUseCase.fetchPostList(min: nil, max: nil)
                    .asObservable()
                    .map { Mutation.setPostList(posts: $0) },
                .just(.setLoading(isLoading: false))
            ])
        case let .like(id):
            postLikeUseCase.like(id: id)
            return postLikeUseCase.completionPublisher
                .compactMap { $0 }
                .filter { $0 }
                .map { _ in Mutation.setLikeButtonStatus(postID: id) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setPostList(posts):
            newState.posts = posts
        case let .setLikeButtonStatus(postID):
            newState.likedPostID = postID
        }
        return newState
    }
}
