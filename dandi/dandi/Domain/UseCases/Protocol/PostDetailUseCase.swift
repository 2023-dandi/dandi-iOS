//
//  PostDetailUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import RxCocoa
import RxSwift

protocol PostDetailUseCase {
    var postPublisher: PublishRelay<Post?> { get }
    func fetchPost(id: Int)
}
