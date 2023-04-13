//
//  WeatherImageType.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/13.
//

import UIKit.UIImage
/*
 - 하늘상태(SKY) 코드 : 맑음(1), 구름많음(3), 흐림(4)
 - 강수형태(PTY) 코드 : (단기) 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4)

 맑음(1) + 없음(0) = 맑음, 강수 없음 : SUNNY or MOON
 맑음(1) + 비(1) = 맑음, 비 : RAINDROPS
 맑음(1) + 비/눈(2) = 맑음, 비/눈 : SNOWRAIN
 맑음(1) + 눈(3) = 맑음, 눈 : SNOW
 맑음(1) + 소나기(4) = 맑음, 소나기 : RAINDROPS
 구름많음(3) + 없음(0) = 구름많음, 강수 없음 : CLOUD
 구름많음(3) + 비(1) = 구름많음, 비 : RAINY
 구름많음(3) + 비/눈(2) = 구름많음, 비/눈 : RAINYSNOWY
 구름많음(3) + 눈(3) = 구름많음, 눈 : SNOWY
 구름많음(3) + 소나기(4) = 구름많음, 소나기 : RAINY
 흐림(4) + 없음(0) = 흐림, 강수 없음 : CLOUDY
 흐림(4) + 비(1) = 흐림, 비 : RAINY

 */

enum WeatherImageType {
    case sunny // 맑음_낮
    case moon // 맑음_밤
    case cloudy // 흐림
    case cloud // 구름 많음
    case raindrops // 비
    case snowrain // 비 눈
    case snow // 눈
    case rainy // 소나기
    case rainysnowy // 빗방울 + 눈날림
    case snowy // 눈 날림

    init(SKY: Int, PTY: Int) {
        switch (SKY, PTY) {
        case (1, 0):
            self = .sunny
        case (1, 1):
            self = .raindrops
        case (1, 2):
            self = .snowrain
        case (1, 3):
            self = .snow
        case (1, 4):
            self = .rainy
        case (3, 0):
            self = .cloud
        case (3, 1):
            self = .rainy
        case (3, 2):
            self = .rainysnowy
        case (3, 3):
            self = .snowy
        case (3, 4):
            self = .rainy
        case (4, 0):
            self = .cloudy
        case (4, 1):
            self = .rainy
        default:
            self = .cloudy
        }
    }

    var image: UIImage {
        switch self {
        case .sunny:
            return Image.sunnyLine
        case .moon:
            return Image.moonLine
        case .cloud:
            return Image.cloudLine
        case .cloudy:
            return Image.cloudyLine
        case .raindrops:
            return Image.raindropsLine
        case .snowrain:
            return Image.snowrainLine
        case .snow:
            return Image.snowLine
        case .rainy:
            return Image.rainyLine
        case .rainysnowy:
            return Image.rainysnowy
        case .snowy:
            return Image.snowyLine
        }
    }
}
