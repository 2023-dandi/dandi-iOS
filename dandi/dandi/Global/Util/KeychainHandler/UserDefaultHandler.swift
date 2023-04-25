//
//  UserDefaultHandler.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/03.
//

struct UserDefaultHandler {
    static var shared = UserDefaultHandler()

    private init() {}

    enum Key: String {
        case accessToken
        case refreshToken
        case fcmToken
        case lon
        case lat
        case locality
    }

    @UserDefault(key: Key.accessToken.rawValue, defaultValue: "")
    var accessToken: String

    @UserDefault(key: Key.refreshToken.rawValue, defaultValue: "")
    var refreshToken: String

    @UserDefault(key: Key.fcmToken.rawValue, defaultValue: "")
    var fcmToken: String

    @UserDefault(key: Key.lon.rawValue, defaultValue: 0.0)
    var lon: Double

    @UserDefault(key: Key.lat.rawValue, defaultValue: 0.0)
    var lat: Double

    @UserDefault(key: Key.locality.rawValue, defaultValue: "")
    var address: String

    func removeAll() {
        _accessToken.reset()
        _refreshToken.reset()
        _lon.reset()
        _lat.reset()
        _address.reset()
    }
}
