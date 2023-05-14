//
//  ChatResultViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/05/14.
//

import UIKit

import Moya
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import YDS

final class ChatResultViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    var question: String? {
        get { return questionLabel.text }
        set { questionLabel.text = newValue }
    }

    var answer: String? {
        get { return answerLabel.text }
        set {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.2
            let attributedText = NSMutableAttributedString(string: newValue ?? "")
            attributedText.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: NSMakeRange(0, attributedText.length)
            )
            answerLabel.attributedText = attributedText
        }
    }

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let questionLabel = PaddingLabel(padding: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
    private let answerLabel = PaddingLabel(padding: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))

    override init() {
        super.init()
        render()
    }

    private func render() {
        questionLabel.cornerRadius = 12
        questionLabel.borderWidth = 1
        questionLabel.borderColor = YDSColor.borderNormal
        questionLabel.font = YDSFont.body1
        questionLabel.numberOfLines = 0

        answerLabel.cornerRadius = 12
        answerLabel.borderWidth = 1
        answerLabel.borderColor = YDSColor.borderNormal
        answerLabel.backgroundColor = YDSColor.bgRecomment
        answerLabel.font = YDSFont.body1
        answerLabel.numberOfLines = 0
        answerLabel.lineBreakMode = .byCharWrapping

        title = "단디챗"

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide.snp.width)
        }
        contentView.addSubview(questionLabel)
        contentView.addSubview(answerLabel)
        questionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        answerLabel.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}
