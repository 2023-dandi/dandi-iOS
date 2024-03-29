//
//  URLConstant.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/03.
//
import Foundation

enum URLConstant {
    static var baseURL: String {
        guard
            let urlString = Bundle.main.object(forInfoDictionaryKey: "Base URL") as? String
        else {
            return ""
        }
        return urlString
    }

    /// 기상청 API
    static let weatherBaseURL: String = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
    static var weatherToken: String {
        guard
            let token = Bundle.main.object(forInfoDictionaryKey: "Weather Token") as? String
        else {
            return ""
        }
        print(token)
        return token
    }

    /// 개인정보 처리방침
    static let policy = "https://github.com/2023-dandi/dandi-docs/wiki/개인정보-처리방침"
    /// EULA
    static let eula = "https://github.com/2023-dandi/dandi-docs/wiki/EULA"
    /// 이용 약관
    static let term = "https://github.com/2023-dandi/dandi-docs/wiki/이용약관"

    /// GPT
    static var gptToken: String {
        guard
            let token = Bundle.main.object(forInfoDictionaryKey: "GPT Token") as? String
        else {
            return ""
        }
        return token
    }
}
