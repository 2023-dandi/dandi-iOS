//
//  ChatViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/05/14.
//

import UIKit

import Moya
import ReactorKit
import RxCocoa
import RxSwift

final class ChatViewController: BaseViewController, View {
//    let provider = MoyaProvider<GPTService>(plugins: [NetworkLogPlugin()])

    override init() {
        super.init()
//        provider.request(.postContent("안녕하세요")) { result in
//            dump(result)
        ////            let decodedResponse: NetworkResult<GPTChatCompletionResponse> = NetworkHandler.requestDecoded(by: result)
        ////
        ////            switch decodedResponse {
        ////            case let .success(response):
        ////                return .success(response.toDomain())
        ////
        ////            case let .failure(error):
        ////                return .failure(error)
        ////            }
//        }
    }

    func bind(reactor: ChatReactor) {
        bindState(reactor)
        bindAction(reactor)
    }

    private func bindState(_ reactor: ChatReactor) {
        reactor.state
            .compactMap { $0.content }
            .subscribe(onNext: { content in
                dump(content)
            })
            .disposed(by: disposeBag)
    }

    private func bindAction(_ reactor: ChatReactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.chat(content: "오늘 뭐입으면 좋을 지 추천해줘") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
