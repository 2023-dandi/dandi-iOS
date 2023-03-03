//
//  URLConstant.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/03.
//
import Foundation

enum Environment {
    static var baseURL: String {
        guard
            let urlString = Bundle.main.object(forInfoDictionaryKey: "Base URL") as? String
        else {
            return ""
        }
        return urlString
    }
}
