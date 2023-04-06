//
//  LoginViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/04.
//

import AuthenticationServices
import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final class LoginViewController: BaseViewController, View {
    typealias Reactor = LoginReactor

    private let appleLoginButton = ASAuthorizationAppleIDButton()
    private let tokenPublisher = PublishRelay<String>()

    override init() {
        super.init()
        setLayouts()
    }

    func bind(reactor: LoginReactor) {
        appleLoginButton.rx.tapGesture
            .subscribe(onNext: {
                let appleIdRequest = ASAuthorizationAppleIDProvider().createRequest()
                let controller = ASAuthorizationController(authorizationRequests: [appleIdRequest])
                controller.delegate = self
                controller.presentationContextProvider = self
                controller.performRequests()
            })
            .disposed(by: disposeBag)

        tokenPublisher
            .map { idToken in Reactor.Action.loginButtonDidTap(fcmToken: "", idToken: idToken) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.isSuccessLogin }
            .withUnretained(self)
            .subscribe(onNext: { _, _ in
                RootSwitcher.update(.main)
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    private func setLayouts() {
        view.addSubview(appleLoginButton)
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller _: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let identityToken = appleIDCredential.identityToken,
            let token = String(data: identityToken, encoding: .utf8)
        else {
            return
        }
        tokenPublisher.accept(token)
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
