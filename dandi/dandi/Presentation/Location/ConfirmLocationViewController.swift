//
//  ConfirmLocationViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/28.
//

import UIKit

import RxCocoa
import RxSwift
import YDS

final class ConfirmLocationViewController: BaseViewController {
    private let label = UILabel()
    private let button = YDSBoxButton()

    private let locality: String
    private let latitude: Double
    private let longitude: Double

    init(locality: String, latitude: Double, longitude: Double) {
        self.locality = locality
        self.latitude = latitude
        self.longitude = longitude

        super.init()
        title = "위치 설정"
        render()
        bind()
        setText(locality)
    }

    private func setText(_ locality: String) {
        label.text = """
        \(locality)의
        날씨로 설정하시겠어요?
        """
    }

    private func render() {
        label.textColor = YDSColor.textSecondary
        label.font = YDSFont.title1
        label.numberOfLines = 0
        label.textAlignment = .left

        button.setBackgroundColor(YDSColor.buttonPoint, for: .normal)
        button.text = "확인"
        button.rounding = .r8
        button.size = .extraLarge

        view.addSubview(label)
        view.addSubview(button)

        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview().offset(-30)
        }
        button.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func bind() {
        button.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                UserDefaultHandler.shared.lat = owner.latitude
                UserDefaultHandler.shared.lon = owner.longitude
                UserDefaultHandler.shared.locality = owner.locality
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
