//
//  SplashViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/16.
//

import UIKit

import ReactorKit

final class SplashViewController: BaseViewController {
    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()

        let shouldUpdateApplication = FirebaseService.shared.stateValuePublisher
            .map { state -> Bool in
                guard
                    let minimumVersion = state.minimumVersion
                else {
                    return false
                }
                let current = Bundle.appVersion.components(separatedBy: ".").map { Int($0)! }
                let minimum = minimumVersion.components(separatedBy: ".").map { Int($0)! }
                return current.lexicographicallyPrecedes(minimum)
            }
            .share()

        shouldUpdateApplication
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.openAppstore()
            })
            .disposed(by: disposeBag)

        shouldUpdateApplication
            .filter { !$0 }
            .subscribe(onNext: { _ in
                guard UserDefaultHandler.shared.accessToken == "" else {
                    RootSwitcher.update(.main)
                    return
                }
                RootSwitcher.update(.login)
            })
            .disposed(by: disposeBag)
    }

    private func setLayouts() {
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(80)
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SplashViewController {
    private func openAppstore() {
        guard
            let url = URL(string: "itms-apps://itunes.apple.com/app/6446045203"),
            UIApplication.shared.canOpenURL(url)
        else {
            return
        }

        rx.makeAlert(
            title: "앱을 사용하려면 최신 버전 업데이트가 필요해요.",
            message: "더 신선한 '단디'를 만나보세요.",
            actions: [Alert(title: "업데이트 하기", style: .default)]
        )
        .subscribe(onNext: { _ in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        .disposed(by: disposeBag)
    }
}
