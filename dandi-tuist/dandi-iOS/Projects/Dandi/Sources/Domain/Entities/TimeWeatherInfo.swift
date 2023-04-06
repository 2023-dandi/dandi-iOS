//
//  TimeWeatherInfo.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/04.
//

import Foundation
import UIKit

struct TodayWeatherInfo {
    let temperatures: Temperatures
    let timeWeahtherInfos: [TimeWeatherInfo]
}

struct TimeWeatherInfo {
    let uuid = UUID()
    let image: UIImage
    let time: String
    let temperature: String
}

extension TimeWeatherInfo: Equatable, Hashable {
    static func == (lhs: TimeWeatherInfo, rhs: TimeWeatherInfo) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

struct Temperatures: Codable {
    let min: Int
    let max: Int
    let description: String?

    init(min: Int, max: Int, description: String? = nil) {
        self.min = min
        self.max = max
        self.description = description
    }
}

extension Temperatures: Equatable {
    static func == (lhs: Temperatures, rhs: Temperatures) -> Bool {
        return lhs.min == rhs.min || lhs.max == rhs.max
    }
}
