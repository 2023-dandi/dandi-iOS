//
//  DefaultCommentRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/04.
//

import Foundation
import Moya
import RxSwift

final class DefaultCommentRepository: CommentRepository {
    let router: MoyaProvider<CommentService>

    init(interceptor: Interceptor) {
        self.router = MoyaProvider<CommentService>(
            session: Session(interceptor: interceptor),
            plugins: [NetworkLogPlugin()]
        )
    }

    func fetchComments(postID: Int) -> Single<NetworkResult<ListWithPage<Comment>>> {
        return router.rx.request(.getComments(postID: postID))
            .map { response in
                let decodedResponse: NetworkResult<CommentWithPageDTO> = NetworkHandler.requestDecoded(by: response)

                switch decodedResponse {
                case let .success(comments):
                    return .success(comments.toDomain())

                case let .failure(error):
                    return .failure(error)
                }
            }
    }

    func postComment(postID: Int, content: String) -> Single<NetworkResult<StatusCase>> {
        return router.rx.request(.postComment(postID: postID, content: content))
            .map { response in
                dump(response)
                let decodedResponse: NetworkResult<StatusCase> = NetworkHandler.requestStatusCaseDecoded(by: response)

                switch decodedResponse {
                case let .success(statusCase):
                    return .success(statusCase)

                case let .failure(error):
                    return .failure(error)
                }
            }
    }

    func deleteComment(postID: Int, commentID: Int) -> Single<NetworkResult<StatusCase>> {
        return router.rx.request(.deleteComment(postID: postID, commentID: commentID))
            .map { response in
                let decodedResponse: NetworkResult<StatusCase> = NetworkHandler.requestStatusCaseDecoded(by: response)

                switch decodedResponse {
                case let .success(statusCase):
                    return .success(statusCase)

                case let .failure(error):
                    return .failure(error)
                }
            }
    }
}
