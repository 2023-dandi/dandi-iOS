//
//  Date+.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/16.
//

import Foundation

extension Date {
    var hour: Int {
        guard let hour = Int(dateToString("HH")) else {
            return 0
        }
        return hour
    }

    func dateToString(_ dateFormat: String = "yyyyMMdd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
