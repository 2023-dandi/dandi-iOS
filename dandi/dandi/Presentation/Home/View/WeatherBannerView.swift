//
//  WeatherBannerCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/04.
//

import UIKit

import SnapKit
import Then
import YDS

final class WeatherBannerView: UIView {
    private(set) lazy var locationLabel = UILabel()
    private(set) lazy var temperatureLabel = UILabel()
    private(set) lazy var descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    public func configure(
        temperature: String,
        description: String
    ) {
        temperatureLabel.text = "\(temperature)℃"
        descriptionLabel.text = description
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WeatherBannerView {
    private func setProperties() {
        locationLabel.do {
            $0.textColor = YDSColor.textPrimary
            $0.textAlignment = .center
            $0.numberOfLines = 1
            $0.font = YDSFont.body1
        }
        temperatureLabel.do {
            $0.textColor = YDSColor.textPrimary
            $0.textAlignment = .center
            $0.numberOfLines = 1
            $0.font = YDSFont.display1
        }
        descriptionLabel.do {
            $0.textColor = YDSColor.textPrimary
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = YDSFont.subtitle3
        }
    }

    private func setLayouts() {
        addSubviews(
            locationLabel,
            temperatureLabel,
            descriptionLabel
        )
        locationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(114)
            make.leading.trailing.equalToSuperview().inset(12).priority(.high)
        }
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(12).priority(.high)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(12).priority(.high)
        }
    }
}
