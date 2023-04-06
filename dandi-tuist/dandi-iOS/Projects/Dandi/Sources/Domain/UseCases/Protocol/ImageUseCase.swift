//
//  ImageUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import UIKit

import RxCocoa
import RxSwift

protocol ImageUseCase {
    var imagePublisher: PublishRelay<String?> { get }
    func uploadImage(image: UIImage)
}
