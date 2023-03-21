//
//  HomeButtonViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/21.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then
import YDS

final class HomeButtonViewController: BaseViewController {
    private let closeButton: UIButton = .init()
    private let closetButton: UIButton = .init()
    private let writingButton: UIButton = .init()

    override init() {
        super.init()
        setProperties()
        setLayouts()
        bind()
    }

    private func bind() {
        Observable.merge([
            view.rx.tapGesture,
            closeButton.rx.tapGesture
        ])
        .withUnretained(self)
        .subscribe(onNext: { owner, _ in
            owner.dismiss(animated: true)
        })
        .disposed(by: disposeBag)
    }

    private func setProperties() {
        view.backgroundColor = YDSColor.dimNormal
        closeButton.do {
            $0.cornerRadius = 30
            $0.backgroundColor = YDSColor.bgNormal
            $0.setImage(
                YDSIcon.xLine
                    .withRenderingMode(.alwaysOriginal)
                    .withTintColor(YDSColor.buttonPoint),
                for: .normal
            )
        }
        [closetButton, writingButton].forEach {
            $0.do {
                $0.cornerRadius = 8
                $0.backgroundColor = YDSColor.bgNormal
                $0.setTitleColor(YDSColor.buttonPoint, for: .normal)
                $0.titleLabel?.font = YDSFont.button0
            }
        }

        closetButton.setTitle("옷 등록", for: .normal)
        writingButton.setTitle("날씨 옷 기록", for: .normal)
    }

    private func setLayouts() {
        let height = tabBarController?.tabBar.frame.height ?? 49.0
        view.addSubviews(closeButton, closetButton, writingButton)
        closeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16 + height)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(60)
        }
        closetButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(closeButton.snp.top).offset(-8)
            make.width.equalTo(120)
            make.height.equalTo(48)
        }
        writingButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(closetButton.snp.top).offset(-8)
            make.width.equalTo(120)
            make.height.equalTo(48)
        }
    }
}
