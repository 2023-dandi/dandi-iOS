//
//  WeatherDetailCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/04.
//

import UIKit

import SnapKit
import Then
import YDS

final class WeatherDetailCollectionViewCell: UICollectionViewCell {
    private let mainImageView = UIImageView()
    private let timeLabel = UILabel()
    private let temperatureLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
        timeLabel.text = nil
        temperatureLabel.text = nil
    }

    public func configure(
        mainImage: UIImage,
        time: String,
        temperature: String
    ) {
        mainImageView.image = mainImage
        timeLabel.text = time
        temperatureLabel.text = temperature + "도"
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WeatherDetailCollectionViewCell {
    private func setProperties() {
        mainImageView.do {
            $0.contentMode = .scaleAspectFill
        }
        timeLabel.do {
            $0.textAlignment = .center
            $0.font = YDSFont.body1
        }
        temperatureLabel.do {
            $0.textAlignment = .center
            $0.font = YDSFont.body2
        }
    }

    private func setLayouts() {
        contentView.addSubviews(
            timeLabel,
            mainImageView,
            temperatureLabel
        )
        timeLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(24)
        }
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(48)
        }
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
}
