//
//  DayWeatherInfo.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/04.
//

import Foundation

struct DayWeatherInfo {
    let uuid = UUID()
    let mainImageURL: String
    let date: String
    let detail: String
}

extension DayWeatherInfo: Equatable, Hashable {
    static func == (lhs: DayWeatherInfo, rhs: DayWeatherInfo) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
