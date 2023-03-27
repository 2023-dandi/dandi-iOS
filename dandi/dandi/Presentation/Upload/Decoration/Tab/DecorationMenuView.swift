//
//  DecorationMenuView.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

import SnapKit
import Then
import YDS

final class DecorationMenuView: UIView {
    var menuBar = UIStackView()
    var buttons: [PagerButton] = []
    var views: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    private func setProperties() {
        backgroundColor = YDSColor.bgNormal
        menuBar.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.borderColor = YDSColor.borderNormal
            $0.borderWidth = YDSConstant.Border.thin
        }
    }

    private func setLayouts() {
        addSubviews(menuBar)
        menuBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
