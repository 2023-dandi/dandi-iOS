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
        case longitude
        case latitude
        case locality
        case min
        case max
    }

    @UserDefault(key: Key.accessToken.rawValue, defaultValue: "")
    var accessToken: String

    @UserDefault(key: Key.refreshToken.rawValue, defaultValue: "")
    var refreshToken: String

    @UserDefault(key: Key.fcmToken.rawValue, defaultValue: "")
    var fcmToken: String

    @UserDefault(key: Key.longitude.rawValue, defaultValue: 0.0)
    var lon: Double

    @UserDefault(key: Key.latitude.rawValue, defaultValue: 0.0)
    var lat: Double

    @UserDefault(key: Key.locality.rawValue, defaultValue: "")
    var address: String

    @UserDefault(key: Key.min.rawValue, defaultValue: -1000)
    var min: Int

    @UserDefault(key: Key.max.rawValue, defaultValue: -1000)
    var max: Int

    func removeAll() {
        _accessToken.reset()
        _refreshToken.reset()
        _lon.reset()
        _lat.reset()
        _address.reset()
    }
}
