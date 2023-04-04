//
//  CommentRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/04.
//

import RxSwift

protocol CommentRepository {
    func fetchComments(postID: Int) -> Single<NetworkResult<ListWithPage<Comment>>>
    func postComment(postID: Int, content: String) -> Single<NetworkResult<StatusCase>>
    func deleteComment(postID: Int, commentID: Int) -> Single<NetworkResult<StatusCase>>
}
