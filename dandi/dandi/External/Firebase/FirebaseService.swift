//
//  FirebaseService.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/25.
//

import Firebase
import FirebaseRemoteConfig
import RxSwift

final class FirebaseService {
    static let shared = FirebaseService()

    private let config = RemoteConfig.remoteConfig().then {
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 6000
        setting.fetchTimeout = 1
        $0.configSettings = setting
    }

    struct State {
        var minimumVersion: String?
    }

    private var state = State()
    private let statePublisher = PublishSubject<State>()

    var stateValuePublisher: PublishSubject<State> {
        if state.minimumVersion != nil {
            fetch()
        }
        return statePublisher
    }

    var stateValue: State {
        return state
    }

    private init() {}

    func start() {
        fetch()
    }

    private func fetch() {
        config.fetch { [weak self] status, _ in
            guard
                let self = self,
                status == .success
            else {
                self?.statePublisher.onNext(self?.state ?? State(minimumVersion: "1.0.0"))
                return
            }
            self.config.activate { _, _ in }
            self.fetchValue()
        }
    }

    private func fetchValue() {
        guard
            let version = config["minimum_version"].stringValue
        else {
            statePublisher.onNext(state)
            return
        }
        let newState = State(
            minimumVersion: version
        )
        statePublisher.onNext(newState)
        state = newState
    }

    func requestNotification() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.badge, .alert, .sound],
            completionHandler: { _, _ in }
        )
    }
}
