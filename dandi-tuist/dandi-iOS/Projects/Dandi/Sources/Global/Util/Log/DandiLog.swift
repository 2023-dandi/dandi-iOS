//
//  DandiLog.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import Foundation

public final class DandiLog {
    public class func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
            let output = items.map { "\($0)" }.joined(separator: separator)
            print("🗣 [\(getCurrentTime())] \(output)", terminator: terminator)
        #endif
    }

    public class func warning(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
            let output = items.map { "\($0)" }.joined(separator: separator)
            print("⚡️ [\(getCurrentTime())] \(output)", terminator: terminator)
        #endif
    }

    public class func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
            let output = items.map { "\($0)" }.joined(separator: separator)
            print("🚨 [\(getCurrentTime())] \(output)", terminator: terminator)
        #endif
    }

    private class func getCurrentTime() -> String {
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateFormatter.string(from: now as Date)
    }
}
