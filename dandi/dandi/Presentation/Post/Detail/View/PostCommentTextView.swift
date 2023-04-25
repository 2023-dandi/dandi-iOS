//
//  PostCommentTextView.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/27.
//

import UIKit

import SnapKit
import Then
import YDS

final class PostCommentTextView: UIView {
    private let divider = YDSDivider(.horizontal)
    private(set) lazy var profileImageView = YDSProfileImageView()
    private(set) lazy var innerTextView = LimitHeightTextView()
    private(set) lazy var placeholderLabel = UILabel()
    private(set) lazy var uploadButton = UIButton()

    init() {
        super.init(frame: .zero)
        setProperties()
        setLayouts()
    }

    func configure(profileImageURL: String?) {
        profileImageView.image(url: profileImageURL, defaultImage: Image.defaultProfile)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setProperties() {
        backgroundColor = YDSColor.bgNormal
        profileImageView.size = .small
        innerTextView.do {
            $0.backgroundColor = .clear
            $0.textColor = YDSColor.textPrimary
            $0.font = YDSFont.body2
            $0.tintColor = YDSColor.buttonPoint
            $0.isScrollEnabled = false
        }
        placeholderLabel.do {
            $0.text = "댓글을 작성해주세요."
            $0.textColor = YDSColor.textTertiary
            $0.font = YDSFont.caption0
        }
        uploadButton.do {
            $0.isEnabled = false

            $0.cornerRadius = YDSConstant.Rounding.r4

            $0.setTitle("등록", for: .normal)
            $0.titleLabel?.font = YDSFont.button4

            $0.setTitleColor(YDSColor.buttonNormal, for: .normal)
            $0.setBackgroundColor(UIColor(red: 236 / 255, green: 238 / 255, blue: 240 / 255, alpha: 1), for: .normal)
        }
    }

    private func setLayouts() {
        addSubviews(divider, profileImageView, placeholderLabel, innerTextView, uploadButton)
        divider.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(12)
        }
        innerTextView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.top.bottom.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(68)
            $0.height.greaterThanOrEqualTo(32)
        }
        placeholderLabel.snp.makeConstraints {
            $0.leading.equalTo(innerTextView.snp.leading).offset(4)
            $0.centerY.equalTo(profileImageView.snp.centerY)
        }
        uploadButton.snp.makeConstraints {
            $0.height.equalTo(33)
            $0.width.equalTo(37)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(profileImageView.snp.centerY)
        }
    }
}

final class LimitHeightTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }

    private let maxHeight: CGFloat = 119

    private var isOverHeight: Bool {
        return contentSize.height >= maxHeight
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        isScrollEnabled = isOverHeight

        if isScrollEnabled == false {
            invalidateIntrinsicContentSize()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
