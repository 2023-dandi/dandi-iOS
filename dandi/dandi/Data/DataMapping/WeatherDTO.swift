//
//  WeatherDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/06.
//

import Foundation

struct WeatherDTO: Decodable {
    let response: WeatherResponseDTO
}

struct WeatherResponseDTO: Decodable {
    let header: WeatherHeaderDTO
    let body: WeatherBodyDTO
}

struct WeatherHeaderDTO: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct WeatherBodyDTO: Decodable {
    let dataType: String
    let items: WeatherItemsDTO
    let pageNo: Int
    let numOfRows: Int
    let totalCount: Int
}

struct WeatherItemsDTO: Decodable {
    let item: [WeatherItemDTO]
}

struct WeatherItemDTO: Decodable {
    let baseDate: String
    let baseTime: String
    let category: WeatherCategoryDTO
    let fcstDate: String
    let fcstTime: String
    let fcstValue: String
    let nx: Int
    let ny: Int
}

enum WeatherCategoryDTO: String, Decodable {
    case tmp = "TMP" // 1시간 기온
    case pop = "POP" // 강수확률
    case pty = "PTY" // 강수형태
    case pcp = "PCP" // 1시간 강수량
    case reh = "REH" // 습도
    case sno = "SNO" // 1시간 신적설
    case sky = "SKY" // 하늘상태
    case tmn = "TMN" // 일 최저기온
    case tmx = "TMX" // 일 최고기온
    case uuu = "UUU" // 풍속(동서성분)
    case vvv = "VVV" // 풍속(남북성분)
    case wav = "WAV" // 파고
    case vec = "VEC" // 풍향
    case wsd = "WSD" // 풍속
}

extension WeatherDTO {
    func toDomain() -> [TimeWeatherInfo] {
        return response.body.items.item
            .filter { $0.category == .tmp }
            .filter { $0.fcstTime >= String(format: "%02d00", Calendar.current.component(.hour, from: Date()))
                && $0.fcstDate == Date().dateToString()
            }
            .map { TimeWeatherInfo(
                image: .add,
                time: TimeConverter().convert24hoursTo12hours(time: (Int($0.fcstTime) ?? 0) / 100),
                temperature: $0.fcstValue
            ) }
    }
}