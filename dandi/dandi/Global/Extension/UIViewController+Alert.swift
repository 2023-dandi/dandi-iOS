//
//  UIViewController+Alert.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/04.
//

import UIKit

extension UIViewController {
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(
            title: "위치 정보 이용",
            message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.",
            preferredStyle: .alert
        )
        let goSetting = UIAlertAction(
            title: "설정으로 이동",
            style: .default
        ) { _ in
            guard let appSetting = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(appSetting)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        present(requestLocationServiceAlert, animated: true)
    }
}
