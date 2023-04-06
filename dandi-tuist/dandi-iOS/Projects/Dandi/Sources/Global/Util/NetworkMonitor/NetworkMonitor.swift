//
//  NetworkMonitor.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/30.
//

import Foundation
import Network

final class NetworkMonitor {
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor: NWPathMonitor

    init() {
        self.monitor = NWPathMonitor()
        dump(monitor)
        print("------------")
    }

    func startMonitoring(statusUpdateHandler: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                statusUpdateHandler(path.status)
            }
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
