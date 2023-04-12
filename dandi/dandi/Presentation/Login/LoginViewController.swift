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
import YDS

final class LoginViewController: BaseViewController, View {
    typealias Reactor = LoginReactor

    private let appleLoginButton = ASAuthorizationAppleIDButton()
    private let tokenPublisher = PublishRelay<String>()
    private let logoImageView = UIImageView(image: Image.logo)
    private let textLogoImageView = UIImageView(image: Image.textLogo)
    private let splash1ImageView = UIImageView(image: Image.splash1)
    private let splash2ImageView = UIImageView(image: Image.splash2)
    private let descriptionLabel = UILabel()

    override init() {
        super.init()
        setProperties()
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
            .subscribe(onNext: { owner, _ in
                let vc = owner.factory.makeLocationSettingViewController(from: .onboarding)
                let nvc = YDSNavigationController(rootViewController: vc)
                nvc.modalPresentationStyle = .fullScreen
                owner.present(nvc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    private func setProperties() {
        [logoImageView,
         textLogoImageView,
         splash1ImageView,
         splash2ImageView].forEach {
            $0.contentMode = .scaleAspectFit
        }
        descriptionLabel.text =
            """
            회원가입을 하면
            Dandi가 날씨별 옷차림을
            단디 챙겨줄 수 있어요!
            """
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = YDSFont.body2
        descriptionLabel.textColor = YDSColor.textSecondary
    }

    private func setLayouts() {
        view.addSubviews(
            logoImageView,
            textLogoImageView,
            appleLoginButton,
            splash1ImageView,
            splash2ImageView,
            descriptionLabel
        )
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(120)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(-80)
        }
        textLogoImageView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(-20)
            $0.centerX.equalTo(logoImageView)
            $0.width.equalTo(94)
            $0.height.equalTo(62)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(textLogoImageView.snp.bottom)
            $0.centerX.equalTo(logoImageView)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        splash1ImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(-20)
            $0.width.equalTo(120)
            $0.height.equalTo(196)
        }
        splash2ImageView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-104)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(30)
            $0.width.equalTo(145)
            $0.height.equalTo(141)
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
