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
    private(set) lazy var searchTextField: YDSSearchTextField = .init()
    private(set) lazy var tableView: UITableView = .init()

    init() {
        super.init(frame: .zero)
        setProperties()
        setLayouts()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LocationSettingView {
    private func setProperties() {
        searchTextField.do {
            $0.placeholder = "위치를 입력해주세요"
        }
    }

    private func setLayouts() {
        addSubviews(searchTextField, tableView)
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(12)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
}
