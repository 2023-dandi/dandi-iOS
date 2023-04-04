//
//  DefaultCommentUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/04.
//

import Foundation

import RxCocoa
import RxSwift

final class DefaultCommentUseCase: CommentUseCase {
    private let commentRepository: CommentRepository

    init(commentRepository: CommentRepository) {
        self.commentRepository = commentRepository
    }

    func fetchComments(postID: Int) -> Observable<[Comment]> {
        return commentRepository.fetchComments(postID: postID)
            .asObservable()
            .map { result in
                switch result {
                case let .success(listWithPage):
                    return listWithPage.list
                case .failure:
                    return []
                }
            }
    }

    func postComment(postID: Int, content: String) -> Observable<Bool> {
        return commentRepository.postComment(postID: postID, content: content)
            .asObservable()
            .map { result in
                switch result {
                case let .success(statusCase):
                    return statusCase == .noContent
                case .failure:
                    return false
                }
            }
    }

    func deleteComment(postID: Int, commentID: Int) -> Observable<Bool> {
        return commentRepository.deleteComment(postID: postID, commentID: commentID)
            .asObservable()
            .map { result in
                switch result {
                case let .success(statusCase):
                    return statusCase == .noContent
                case .failure:
                    return false
                }
            }
    }
}
