//
//  TimeWeatherInfo.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/04.
//

import Foundation
import UIKit

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
