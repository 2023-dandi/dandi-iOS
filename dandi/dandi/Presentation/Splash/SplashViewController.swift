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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard KeychainHandler.shared.accessToken == "" else {
                RootSwitcher.update(.main)
                return
            }
            RootSwitcher.update(.login)
        }
    }

    private func setLayouts() {
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(80)
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
