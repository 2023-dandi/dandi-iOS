//
//  UploadWeatherCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/16.
//

import UIKit

import SnapKit
import YDS

final class UploadWeatherCollectionViewCell: UICollectionViewCell {
    private let label = UILabel()
    private let control = InformationControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(min: Int, max: Int) {
        control.text = "최고\(max)/최저\(min)"
    }

    private func setProperties() {
        label.font = YDSFont.title3
        label.text = "날씨"
        control.text = "..."
    }

    private func setLayouts() {
        contentView.addSubviews(label, control)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        control.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(label.snp.trailing).inset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(30)
            $0.width.equalTo(120)
        }
    }
}

final class InformationControl: UIControl {
    private let label = UILabel()
    private let informationIcon = UIImageView()

    var text: String = "" {
        didSet { label.text = text }
    }

    init() {
        super.init(frame: .zero)
        setProperties()
        setLayouts()
    }

    private func setProperties() {
        label.font = YDSFont.body1
        label.textColor = YDSColor.textPrimary

        informationIcon.image = YDSIcon.warningcircleLine
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(YDSColor.buttonDisabled)
    }

    private func setLayouts() {
        addSubview(label)
        addSubview(informationIcon)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
        }
        informationIcon.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(label.snp.trailing).offset(4)
            $0.trailing.greaterThanOrEqualToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
