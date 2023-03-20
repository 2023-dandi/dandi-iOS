//
//  LikeUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/21.
//

import UIKit

import RxCocoa
import RxSwift

protocol LikeUseCase {
    var completionPublisher: PublishRelay<Bool?> { get }
    func like(id: Int)
}
