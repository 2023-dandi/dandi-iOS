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

final class WeatherBannerCollectionViewCell: UICollectionViewCell {
    private let mainImageView = UIImageView()
    private let dateLabel = YDSLabel(style: .subtitle3)
    private let contentLabel = UILabel()
    private let rightArrowButton = UIButton()
    private let leftArrowButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
        dateLabel.text = nil
        contentLabel.text = nil
    }

    public func configure(
        mainImageURL: String,
        date: String,
        content: String
    ) {
        mainImageView.image(url: mainImageURL)
        dateLabel.text = date
        contentLabel.text = content
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WeatherBannerCollectionViewCell {
    private func setProperties() {
        mainImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.alpha = 0.3
        }
        contentLabel.do {
            $0.textColor = YDSColor.textSecondary
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = YDSFont.title2
        }
        leftArrowButton.do {
            $0.setImage(YDSIcon.arrowLeftLine, for: .normal)
        }
        rightArrowButton.do {
            $0.setImage(YDSIcon.arrowRightLine, for: .normal)
        }
    }

    private func setLayouts() {
        contentView.addSubviews(
            mainImageView,
            dateLabel,
            contentLabel,
            leftArrowButton,
            rightArrowButton
        )
        mainImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.centerX.equalToSuperview()
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(19)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(65)
        }
        leftArrowButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        rightArrowButton.snp.makeConstraints { make in
            make.right.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
    }
}
