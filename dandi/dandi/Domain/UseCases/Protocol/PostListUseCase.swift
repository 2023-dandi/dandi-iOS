//
//  PostListUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import RxCocoa
import RxSwift

protocol PostListUseCase {
    var postsPublisher: PublishRelay<[MyPost]> { get }
    func fetchPostList()
}
