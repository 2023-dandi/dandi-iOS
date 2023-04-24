//
//  ReportAndBlockUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/24.
//

import RxSwift

protocol ReportAndBlockUseCase {
    func reportComment(commentId: Int) -> Single<Bool>
    func reportPost(postId: Int) -> Single<Bool>
    func blockUser(userId: Int) -> Single<Bool>
}
