//
//  DateParser.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/25.
//

import Foundation

struct DateParser {
    static let shared = DateParser()

    func toKorean(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = formatter.date(from: date)
        formatter.dateFormat = "yyyy년MM월dd일"
        let date = formatter.string(from: convertedDate!)
        return date
    }
}
