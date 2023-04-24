//
//  DefaultReportAndBlockUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/24.
//

import RxSwift

final class DefaultReportAndBlockUseCase: ReportAndBlockUseCase {
    private let commentRepository: CommentRepository
    private let postRepository: PostRepository
    private let memberRepository: MemberRepository

    init(
        commentRepository: CommentRepository,
        postRepository: PostRepository,
        memberRepository: MemberRepository
    ) {
        self.commentRepository = commentRepository
        self.postRepository = postRepository
        self.memberRepository = memberRepository
    }

    func reportComment(commentId: Int) -> RxSwift.Single<Bool> {
        return commentRepository.reportComment(commentID: commentId)
            .map { result in
                switch result {
                case let .success(statusCase):
                    return statusCase == .created
                case .failure:
                    return false
                }
            }
    }

    func reportPost(postId: Int) -> RxSwift.Single<Bool> {
        return postRepository.reportPost(id: postId)
            .map { result in
                switch result {
                case let .success(statusCase):
                    return statusCase == .created
                case .failure:
                    return false
                }
            }
    }

    func blockUser(userId: Int) -> RxSwift.Single<Bool> {
        return memberRepository.blockUser(userID: userId)
            .map { result in
                switch result {
                case let .success(statusCase):
                    return statusCase == .created
                case .failure:
                    return false
                }
            }
    }
}
