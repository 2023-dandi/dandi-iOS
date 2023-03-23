//
//  LocationUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/24.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift

protocol LocationUseCase {
    var locationPublisher: PublishRelay<String> { get }
    func fetchLocation()
}
