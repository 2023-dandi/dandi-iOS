//
//  UploadPostUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol UploadPostUseCase {
    var postIdPublusher: PublishRelay<Int?> { get }
    func uploadPost(
        imageURL: String,
        temperatures: Temperatures,
        clothesFeeling: ClothesFeeling,
        weatherFeelings: [WeatherFeeling]
    )
}
