//
//  PostListUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/28.
//

import RxCocoa
import RxSwift

protocol PostListUseCase {
    var postsPublisher: PublishRelay<[Post]> { get }
    func fetchPostList(min: Int, max: Int)
}
