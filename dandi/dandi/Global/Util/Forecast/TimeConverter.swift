//
//  TimeConverter.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/07.
//

import Foundation

struct TimeConverter {
    /*
     - Base_time : 0200, 0500, 0800, 1100, 1400, 1700, 2000, 2300 (1일 8회)
     - API 제공 시간(~이후) : 02:10, 05:10, 08:10, 11:10, 14:10, 17:10, 20:10, 23:10
     */
    func getBaseDateAndBaseTime() -> (String, String) {
        let now = Date()
        var baseDate = now.dateToString()
        var baseTime = String(format: "%02d00", Calendar.current.component(.hour, from: now))

        if baseTime > "2310" {
            baseTime = "2300"
        } else if baseTime > "2010" {
            baseTime = "2000"
        } else if baseTime > "1710" {
            baseTime = "1700"
        } else if baseTime > "1410" {
            baseTime = "1400"
        } else if baseTime > "1110" {
            baseTime = "1100"
        } else if baseTime > "0810" {
            baseTime = "0800"
        } else if baseTime > "0510" {
            baseTime = "0500"
        } else if baseTime > "0210" {
            baseTime = "0200"
        } else {
            let yesterday = now - 86400
            baseDate = yesterday.dateToString()
            baseTime = "2300"
        }
        return (baseDate, baseTime)
    }

    func convert24hoursTo12hours(time: Int) -> String {
        if time == 0 {
            return "오전12시"
        }
        if time < 12 {
            return "오전\(time)시"
        }
        if time == 12 {
            return "오후12시"
        }
        return "오후\(time - 12)시"
    }
}

extension Date {
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: self)
    }
}
