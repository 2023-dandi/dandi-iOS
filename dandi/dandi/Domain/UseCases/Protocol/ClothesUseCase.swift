//
//  ClothesUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/31.
//

import Foundation

import UIKit

import RxCocoa
import RxSwift

protocol ClothesUseCase {
    var deleteSuccessPublisher: PublishRelay<Bool> { get }
    func delete(id: Int)
}
