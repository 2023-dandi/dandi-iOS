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

    let disposeBag = DisposeBag()

    private let postDetailUseCase: PostDetailUseCase
    private let postLikeUseCase: LikeUseCase
    private let commentUseCase: CommentUseCase
    private let reportAndBlockUseCase: ReportAndBlockUseCase
    private let postID: Int

    struct State {
        var isLiked: Bool?
        var isLoading: Bool = false
        var post: Post?
        var isDeleted: Bool = false
        var isReportedPost: Bool = false
        var isReportedComment: Bool = false
        var isBlockedUser: Bool = false
        var comments: [Comment]?
    }

    enum Action {
        case fetchPostDetail
        case like
        case delete
        case fetchComments
        case reportPost
        case blockUser(userID: Int)
        case postComment(content: String)
        case deleteComment(commentID: Int)
        case reportComment(commentID: Int)
    }

    enum Mutation {
        case setLoading(isLoading: Bool)
        case setPost(Post)
        case setLikeButtonStatus(isLiked: Bool)
        case setDeleteStatus(Bool)
        case setReportPostStatus(Bool)
        case setReportCommentStatus(Bool)
        case setBlockUserStatus(Bool)
        case setComments([Comment])
    }

    init(
        postID: Int,
        postDetailUseCase: PostDetailUseCase,
        postLikeUseCase: LikeUseCase,
        commentUseCase: CommentUseCase,
        reportAndBlockUseCase: ReportAndBlockUseCase
    ) {
        self.initialState = State()
        self.postDetailUseCase = postDetailUseCase
        self.postLikeUseCase = postLikeUseCase
        self.commentUseCase = commentUseCase
        self.reportAndBlockUseCase = reportAndBlockUseCase
        self.postID = postID
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchPostDetail:
            postDetailUseCase.fetchPost(id: postID)
            return postDetailUseCase.postPublisher
                .compactMap { $0 }
                .map { Mutation.setPost($0) }

        case .like:
            postLikeUseCase.like(id: postID)
            return postLikeUseCase.completionPublisher
                .compactMap { $0 }
                .map { Mutation.setLikeButtonStatus(isLiked: $0) }

        case .delete:
            postDetailUseCase.delete(id: postID)
            return postDetailUseCase.deleteSuccessPublisher
                .map { Mutation.setDeleteStatus($0) }

        case .fetchComments:
            return commentUseCase.fetchComments(postID: postID)
                .map { Mutation.setComments($0) }

        case let .postComment(content):
            return commentUseCase.postComment(postID: postID, content: content)
                .filter { $0 }
                .flatMap { _ in self.commentUseCase.fetchComments(postID: self.postID) }
                .map { Mutation.setComments($0) }

        case let .deleteComment(commentID):
            return commentUseCase.deleteComment(postID: postID, commentID: commentID)
                .flatMap { _ in self.commentUseCase.fetchComments(postID: self.postID) }
                .map { Mutation.setComments($0) }

        case .reportPost:
            return reportAndBlockUseCase.reportPost(postId: postID)
                .asObservable()
                .map { Mutation.setReportPostStatus($0) }

        case let .reportComment(commentID):
            return reportAndBlockUseCase.reportComment(commentId: commentID)
                .asObservable()
                .flatMap { _ in self.commentUseCase.fetchComments(postID: self.postID) }
                .map { Mutation.setComments($0) }

        case let .blockUser(userID):
            return reportAndBlockUseCase.blockUser(userId: userID)
                .asObservable()
                .map { Mutation.setBlockUserStatus($0) }
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
        case let .setDeleteStatus(isDeleted):
            newState.isDeleted = isDeleted
        case let .setComments(comments):
            newState.comments = comments
        case let .setReportPostStatus(isReportedPost):
            newState.isReportedPost = isReportedPost
        case let .setReportCommentStatus(isReportedComment):
            newState.isReportedComment = isReportedComment
        case let .setBlockUserStatus(isBlockedUser):
            newState.isBlockedUser = isBlockedUser
        }
        return newState
    }
}
