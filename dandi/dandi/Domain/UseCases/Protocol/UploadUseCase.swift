//
//  UploadUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol UploadUseCase {
    var imagePublisher: PublishRelay<String?> { get }
    var postIdPublusher: PublishRelay<Int?> { get }
    func uploadImage(image: UIImage)
    func uploadPost(
        imageURL: String,
        temperatures: Temperatures,
        clothesFeeling: ClothesFeeling,
        weatherFeelings: [WeatherFeeling]
    )
}
