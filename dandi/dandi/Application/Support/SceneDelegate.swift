//
//  SceneDelegate.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let networkMonitor = NetworkMonitor()
    var errorWindow: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        startNetworkMonitoring(on: windowScene)
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        RootSwitcher.update(.main)
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
    }

    func sceneDidDisconnect(_: UIScene) {
        networkMonitor.stopMonitoring()
    }

    func sceneDidBecomeActive(_: UIScene) {}

    func sceneWillResignActive(_: UIScene) {}

    func sceneWillEnterForeground(_: UIScene) {}

    func sceneDidEnterBackground(_: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

extension SceneDelegate {
    private func startNetworkMonitoring(on scene: UIScene) {
        networkMonitor.startMonitoring(statusUpdateHandler: { [weak self] connectionStatus in
            switch connectionStatus {
            case .satisfied:
                self?.removeNetworkErrorWindow()
                print("dismiss networkError View if is present")
            case .unsatisfied:
                self?.loadNetworkErrorWindow(on: scene)
                print("No Internet!! show network Error View")
            default:
                break
            }
        })
    }

    private func loadNetworkErrorWindow(on scene: UIScene) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.windowLevel = .statusBar
            window.makeKeyAndVisible()
            let networkErrorView = NetworkErrorView(frame: window.frame)
            window.addSubview(networkErrorView)
            errorWindow = window
        }
    }

    private func removeNetworkErrorWindow() {
        errorWindow?.resignKey()
        errorWindow?.isHidden = true
        errorWindow = nil
    }
}
