//
//  KeychainHandler.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/03.
//

// TODO: - 고치기
struct KeychainHandler {
    static var shared = KeychainHandler()

    private init() {}

    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let fcmTokenKey = "fcmToken"

    var accessToken: String = ""

    var refreshToken: String = ""

    var fcmToken: String = ""
}
