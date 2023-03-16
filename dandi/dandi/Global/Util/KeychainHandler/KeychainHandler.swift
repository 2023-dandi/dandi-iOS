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

    enum Key: String {
        case accessToken
        case refreshToken
    }

    @UserDefault(key: Key.accessToken.rawValue, defaultValue: "")
    var accessToken: String

    @UserDefault(key: Key.refreshToken.rawValue, defaultValue: "")
    var refreshToken: String

    func removeAll() {
        _accessToken.reset()
        _refreshToken.reset()
    }
}
