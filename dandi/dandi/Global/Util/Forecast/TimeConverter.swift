//
//  TimeConverter.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/07.
//

import Foundation

struct TimeConverter {
    static let shared = TimeConverter()
    /*
     - Base_time : 0200, 0500, 0800, 1100, 1400, 1700, 2000, 2300 (1일 8회)
     - API 제공 시간(~이후) : 02:10, 05:10, 08:10, 11:10, 14:10, 17:10, 20:10, 23:10
     */
    func getBaseDateAndBaseTime() -> (String, String) {
        let now = Date()
        var baseDate = now.dateToString()
        var baseTime = String(format: "%02d00", Calendar.current.component(.hour, from: now))
        let baseTimeInt = Int(baseTime) ?? 0

        switch baseTimeInt {
        case 0 ..< 210:
            let yesterday = now - 86400
            baseDate = yesterday.dateToString()
            baseTime = "2300"
        case 210 ..< 510:
            baseTime = "0200"
        case 510 ..< 810:
            baseTime = "0500"
        case 810 ..< 1110:
            baseTime = "0800"
        case 1110 ..< 1410:
            baseTime = "1100"
        case 1410 ..< 1710:
            baseTime = "1400"
        case 1710 ..< 2010:
            baseTime = "1700"
        case 2010 ..< 2310:
            baseTime = "2000"
        default:
            baseTime = "2300"
        }

        return (baseDate, baseTime)
    }

    func convert24hoursTo12hours(time: Int) -> String {
        switch time {
        case 0:
            return "오전12시"
        case 1 ..< 12:
            return "오전\(time)시"
        case 12:
            return "오후12시"
        case 13 ..< 24:
            return "오후\(time - 12)시"
        default:
            return ""
        }
    }

    func convertDate(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = formatter.date(from: date)
        formatter.dateFormat = "yyyy.MM.dd"
        let date = formatter.string(from: convertedDate!)
        return date
    }
}
