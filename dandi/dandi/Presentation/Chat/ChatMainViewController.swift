//
//  ChatMainViewController.swift
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

final class ChatMainViewController: BaseViewController, View {
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let textView = PlaceholderTextView()
    private let textPublisher = PublishSubject<String>()

    private var question: String?

    override init() {
        super.init()
        hideKeyboardWhenTappedAround()
        setProperties()
        setLayouts()
    }

    func bind(reactor: ChatReactor) {
        bindState(reactor)
        bindAction(reactor)
    }

    private func bindState(_ reactor: ChatReactor) {
        reactor.state
            .compactMap { $0.content }
            .subscribe(onNext: { [weak self] content in
                let vc = ChatResultViewController()
                vc.question = self?.question
                vc.answer = content
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func bindAction(_ reactor: ChatReactor) {
        textPublisher
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .map { Reactor.Action.chat(content: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func setProperties() {
        titleLabel.text = "질문을 입력하면 단디가 답해드려요!"
        titleLabel.font = YDSFont.subtitle2
        titleLabel.textAlignment = .center

        logoImageView.image = Image.logo

        textView.placeholder = "질문을 입력해보세요."

        textView.textView.delegate = self
        textView.textView.returnKeyType = .send
    }

    private func setLayouts() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(textView)
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(62)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
    }
}

extension ChatMainViewController: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn _: NSRange,
        replacementText text: String
    ) -> Bool {
        guard text == "\n" else { return true }

        textView.resignFirstResponder()
        question = textView.text
        textPublisher.onNext("현재 계절 초여름이며 최고\(UserDefaultHandler.shared.max)도/최저\(UserDefaultHandler.shared.min)도의 날씨야. 너는 패션 코디를 담당해주는 아이야. 패션에 관해서 답변해줘." + textView.text)

        return false
    }
}
