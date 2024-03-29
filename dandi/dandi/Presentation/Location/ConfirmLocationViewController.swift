//
//  ConfirmLocationViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/28.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import YDS

final class ConfirmLocationViewController: BaseViewController, View {
    private let label = UILabel()
    private let button = YDSBoxButton()

    private let locality: String
    private let latitude: Double
    private let longitude: Double

    let from: LocationSettingViewController.From

    init(locality: String, latitude: Double, longitude: Double, from: LocationSettingViewController.From) {
        self.from = from
        self.locality = locality
        self.latitude = latitude
        self.longitude = longitude

        super.init()
        title = "위치 설정"
        render()
        setText(locality)
    }

    func bind(reactor: ConfirmLocationReactor) {
        button.rx.tap
            .withUnretained(self)
            .map { owner, _ in
                Reactor.Action.setLoaction(
                    lat: owner.latitude,
                    lon: owner.longitude,
                    address: owner.locality
                )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.isSuccessChangeLocation }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                switch self.from {
                case .default:
                    NotificationCenterManager.reloadLocation.post()
                    self.dismiss(animated: true)
                case .onboarding:
                    RootSwitcher.update(.main)
                }

            })
            .disposed(by: disposeBag)
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
}
