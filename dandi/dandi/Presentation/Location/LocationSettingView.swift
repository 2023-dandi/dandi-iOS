//
//  LocationSettingView.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/05.
//

import UIKit

import Then
import YDS

final class LocationSettingView: UIView {
    private let titleLabel: UILabel = .init()
    private let searchTextField: YDSSearchTextField = .init()
    private let tableView: UITableView = .init()

    init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LocationSettingView {
    private func setProperties() {
        titleLabel.do {
            $0.text = "위치 설정"
            $0.font = YDSFont.title3
        }
        searchTextField.do {
            $0.placeholder = "위치를 입력해주세요"
        }
    }

    private func setLayouts() {
        addSubviews(titleLabel, searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
    }
}
