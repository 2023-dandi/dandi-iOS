//
//  DecorationHeaderView.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/13.
//

import UIKit

import SnapKit
import Then
import YDS

final class DecorationHeaderView: UICollectionReusableView {
    static let identifier = "DecorationHeaderView"
    private(set) lazy var rawImageView: UIView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayouts()
    }

    private func setLayouts() {
        addSubview(rawImageView)
        rawImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rawImageView.clipsToBounds = true
        backgroundColor = YDSColor.bgDimDark
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
