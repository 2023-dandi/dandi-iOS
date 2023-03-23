//
//  MemberInfoUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import RxCocoa
import RxSwift

protocol MemberInfoUseCase {
    var memberInfoPublisher: PublishRelay<UserProfile?> { get }
    func fetchUserInfo()
}
