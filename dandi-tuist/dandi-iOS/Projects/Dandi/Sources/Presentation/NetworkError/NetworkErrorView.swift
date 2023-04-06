//
//  NetworkErrorView.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/30.
//

import UIKit

import RxCocoa
import RxSwift
import YDS

final class NetworkErrorView: UIView {
    private let emoji = UILabel().then {
        $0.text = "⚠️"
        $0.font = .systemFont(ofSize: 90)
        $0.textAlignment = .center
    }

    private let textLabel = UILabel().then {
        $0.text = "네트워크를 확인해주세요."
        $0.font = YDSFont.subtitle1
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black.withAlphaComponent(0.7)
        render()
    }

    private func render() {
        addSubview(emoji)
        addSubview(textLabel)
        emoji.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.size.equalTo(100)
        }
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(emoji.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
