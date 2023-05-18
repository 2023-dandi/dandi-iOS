//
//  PlaceholderTextView.swift
//  dandi
//
//  Created by 김윤서 on 2023/05/14.
//
import UIKit

import YDS

final class PlaceholderTextView: UIView {
    var placeholder: String? {
        get { return placeholderLabel.text }
        set { placeholderLabel.text = newValue }
    }

    var text: String? {
        get { return textView.text }
        set {
            textView.text = newValue
            guard let text = newValue else { return }
            placeholderLabel.isHidden = !text.isEmpty
            clearButton.isHidden = text.isEmpty
        }
    }

    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = YDSIcon.searchLine
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(YDSColor.textTertiary)
        return imageView
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = YDSColor.textTertiary
        return label
    }()

    private(set) lazy var textView: DynamicHeightTextView = {
        let textView = DynamicHeightTextView()
        return textView
    }()

    private let clearButton = UIButton()

    init() {
        super.init(frame: .zero)
        render()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
        clearButton.addTarget(self, action: #selector(clearButtonDidTap), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        render()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func render() {
        backgroundColor = YDSColor.inputFieldElevated
        cornerRadius = 8

        textView.font = YDSFont.body1
        textView.backgroundColor = .clear
        textView.tintColor = YDSColor.textPointed

        placeholderLabel.font = YDSFont.body1

        clearButton.setImage(
            YDSIcon.xLine
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(YDSColor.textTertiary),
            for: .normal
        )
        clearButton.isHidden = true

        addSubviews(placeholderLabel, textView, searchIcon, clearButton)
        searchIcon.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        placeholderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(44)
            $0.trailing.equalToSuperview().inset(16)
        }
        textView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.equalToSuperview().inset(40)
            $0.trailing.equalToSuperview().inset(34)
        }
        clearButton.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.trailing.equalToSuperview().inset(9)
            $0.centerY.equalToSuperview()
        }
    }

    @objc
    private func textDidChange() {
        guard let text = text else { return }
        placeholderLabel.isHidden = !text.isEmpty
        clearButton.isHidden = text.isEmpty
    }

    @objc
    private func clearButtonDidTap() {
        text = ""
    }
}
