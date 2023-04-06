//
//  PagerButton.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/26.
//

import UIKit

import YDS

final class PagerButton: UIButton {
    override var isSelected: Bool {
        didSet {
            bottomLine.isHidden = !isSelected
        }
    }

    private let bottomLine = UIView()

    init(_ text: String) {
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        render()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func render() {
        titleLabel?.font = YDSFont.button2
        titleLabel?.textAlignment = .center

        setTitleColor(YDSColor.bottomBarSelected, for: .selected)
        setTitleColor(YDSColor.bottomBarNormal, for: .normal)

        bottomLine.isHidden = !isSelected
        bottomLine.backgroundColor = YDSColor.bottomBarSelected

        addSubviews(bottomLine)
        bottomLine.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
}
