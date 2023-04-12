//
//  String+.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/07.
//

import Foundation

extension String {
    func toInt() -> Int {
        return Int(self) ?? 0
    }

    func toDouble() -> Double {
        return Double(self) ?? 0.0
    }
    
    func trimmingSpace() -> String {
        return trimmingCharacters(in: CharacterSet(charactersIn: " "))
    }
}
