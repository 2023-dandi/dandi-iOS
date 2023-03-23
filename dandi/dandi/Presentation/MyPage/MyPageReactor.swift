//
//  MyPageReactor.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import ReactorKit
import RxCocoa
import RxSwift

final class MyPageReactor: Reactor {
    let initialState: State

    private let memberInfoUseCase: MemberInfoUseCase
    private let postListUseCase: PostListUseCase

    struct State {
        var isLoading: Bool = false
        var profile: UserProfile?
        var posts: [MyPost] = []
    }

    enum Action {
        case fetchProfile
        case fetchMyPosts
    }

    enum Mutation {
        case setUserProfile(UserProfile)
        case setMyPostList([MyPost])
    }

    init(
        memberInfoUseCase: MemberInfoUseCase,
        postListUseCase: PostListUseCase
    ) {
        self.initialState = State()
        self.memberInfoUseCase = memberInfoUseCase
        self.postListUseCase = postListUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchProfile:
            memberInfoUseCase.fetchUserInfo()
            return memberInfoUseCase.memberInfoPublisher
                .compactMap { $0 }
                .compactMap { Mutation.setUserProfile($0) }
        case .fetchMyPosts:
            postListUseCase.fetchPostList()
            return postListUseCase.postsPublisher
                .map { Mutation.setMyPostList($0) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setUserProfile(userProfile):
            newState.profile = userProfile
        case let .setMyPostList(posts):
            newState.posts = posts
        }
        return newState
    }
}
