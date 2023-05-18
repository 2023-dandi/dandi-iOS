//
//  ChatMainViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/05/14.
//

import UIKit

import Lottie
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
    private let animationView = LottieAnimationView()

    private let contentStackView = UIStackView()

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
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] content in
                let vc = ChatResultViewController()
                vc.question = self?.question
                vc.answer = content
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.isLoading }
            .subscribe(onNext: { [weak self] isLoading in
//                self?.animationView.isHidden = !isLoading
                self?.view.isUserInteractionEnabled = !isLoading

                UIView.animate(withDuration: 0.3) {
                    self?.animationView.alpha = !isLoading ? 0 : 1
                    self?.contentStackView.alpha = !isLoading ? 1 : 0
                }

                if isLoading {
                    self?.animationView.play()
                    return
                }
                self?.animationView.stop()
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

        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.alignment = .center

        animationView.animation = .named("loading")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.alpha = 0

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func setLayouts() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(textView)
        view.addSubview(contentStackView)
        view.addSubview(animationView)
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(70)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(0)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(textView.snp.bottom).offset(60)
        }
        setContentStackView()
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(100)
        }
    }

    private let contents = [
        0: "결혼식에는 뭘 입고 가면 좋을까요?",
        1: "롱스커트에는 무슨 상의를 입으면 좋을까요?",
        2: "파티에 입고 갈 옷을 추천해주세요!",
        3: "개강룩으로 뭐를 입으면 좋을까요?"
    ]

    private func setContentStackView() {
        let label = UILabel()
        label.text = "빠른 검색"
        label.textColor = YDSColor.textTertiary
        label.font = YDSFont.caption0
        contentStackView.addArrangedSubview(label)

        for content in contents {
            let button = UIButton()
            button.borderWidth = 1
            button.borderColor = YDSColor.borderNormal
            button.cornerRadius = 4

            button.titleLabel?.font = YDSFont.body1
            button.setTitleColor(YDSColor.monoItemText, for: .normal)
            button.setTitle(content.value, for: .normal)
            button.contentEdgeInsets = UIEdgeInsets(
                top: 4,
                left: 8,
                bottom: 4,
                right: 8
            )
            button.tag = content.key
            button.addTarget(
                self,
                action: #selector(contentButtonDidTap),
                for: .touchUpInside
            )
            contentStackView.addArrangedSubview(button)
        }
    }

    private func setTextViewText(_ text: String) {
        textView.text = text
        question = text
        textPublisher.onNext("현재 계절 초여름이며 최고\(UserDefaultHandler.shared.max)도/최저\(UserDefaultHandler.shared.min)도의 날씨야. 너는 패션 코디를 담당하는 사람이라 생각하고 패션에 관해서 답변해줘." + text)
    }

    @objc
    private func contentButtonDidTap(_ sender: UIButton) {
        guard let content = contents[sender.tag] else { return }
        setTextViewText(content)
    }

    @objc
    private func keyboardWillShow(_: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.logoImageView.snp.updateConstraints {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(100)
            }
            self.view.layoutIfNeeded()
            self.contentStackView.alpha = 0
        }
    }

    @objc
    private func keyboardWillHide(_: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.logoImageView.snp.updateConstraints {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(0)
            }
            self.view.layoutIfNeeded()
            self.contentStackView.alpha = 1
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
        setTextViewText(textView.text)

        return false
    }
}
