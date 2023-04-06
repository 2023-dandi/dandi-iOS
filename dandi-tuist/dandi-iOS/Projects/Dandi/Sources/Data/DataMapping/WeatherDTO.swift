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
    func toDomain() -> TodayWeatherInfo {
        let timeWeahtherInfos = response.body.items.item
            .filter { $0.category == .tmp }
            .filter {
                ($0.fcstTime.toInt() >= String(format: "%02d00", Calendar.current.component(.hour, from: Date())).toInt()
                    && $0.fcstDate.toInt() == Date().dateToString().toInt())
                    || ($0.fcstDate.toInt() > Date().dateToString().toInt())
            }
            .map { TimeWeatherInfo(
                image: .add,
                time: TimeConverter().convert24hoursTo12hours(time: $0.fcstTime.toInt() / 100),
                temperature: $0.fcstValue
            ) }

        let min = response.body.items.item
            .filter { $0.category == .tmn }
            .map { $0.fcstValue.toDouble() }
            .first

        let max = response.body.items.item
            .filter { $0.category == .tmx }
            .map { $0.fcstValue.toDouble() }
            .first

        let temperatures = Temperatures(min: Int(min ?? -1), max: Int(max ?? -1))
        return TodayWeatherInfo(temperatures: temperatures, timeWeahtherInfos: timeWeahtherInfos)
    }

    func toDomain() -> [TimeWeatherInfo] {
        return response.body.items.item
            .filter { $0.category == .tmp }
            .filter {
                ($0.fcstTime.toInt() >= String(format: "%02d00", Calendar.current.component(.hour, from: Date())).toInt()
                    && $0.fcstDate.toInt() == Date().dateToString().toInt())
                    || ($0.fcstDate.toInt() > Date().dateToString().toInt())
            }
            .map { TimeWeatherInfo(
                image: .add,
                time: TimeConverter().convert24hoursTo12hours(time: $0.fcstTime.toInt() / 100),
                temperature: $0.fcstValue
            ) }
    }

    func toDomain() -> Temperatures {
        let min = response.body.items.item
            .filter { $0.category == .tmn }
            .map { $0.fcstValue.toDouble() }
            .first

        let max = response.body.items.item
            .filter { $0.category == .tmx }
            .map { $0.fcstValue.toDouble() }
            .first

        dump(min)
        dump(max)

        return Temperatures(min: Int(min ?? -1), max: Int(max ?? -1))
    }
}
