//
//  CommentUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/04.
//

import RxSwift

protocol CommentUseCase {
    func fetchComments(postID: Int) -> Observable<[Comment]>
    func postComment(postID: Int, content: String) -> Observable<Bool>
    func deleteComment(postID: Int, commentID: Int) -> Observable<Bool>
}
