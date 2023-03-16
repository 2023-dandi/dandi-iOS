//
//  WeatherFeeling.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/16.
//

enum WeatherFeeling: Int, CaseIterable {
    case coldInMornigAndNight = 0
    case hotInDay = 1
    case hotEasily = 2
    case coldEasily = 3
    case outside = 4
    case inside = 5

    var text: String {
        switch self {
        case .coldInMornigAndNight:
            return "아침/밤에는 추워요"
        case .hotInDay:
            return "낮에는 더워요"
        case .hotEasily:
            return "더위를 타는 편이에요"
        case .coldEasily:
            return "추위를 타는 편이에요"
        case .outside:
            return "야외활동을 하기에 딱 이에요"
        case .inside:
            return "실내에 있기 좋아요"
        }
    }
}
