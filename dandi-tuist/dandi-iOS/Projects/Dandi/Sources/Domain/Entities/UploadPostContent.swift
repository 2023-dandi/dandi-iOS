//
//  UploadPostContent.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/31.
//

import Foundation

struct UploadPostContent {
    let postImageURL: String
    let clothesFeeling: ClothesFeeling
    let weatherFeelings: [WeatherFeeling]
    let temperatures: Temperatures
}
