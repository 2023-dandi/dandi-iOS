//
//  DefaultGPTRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/05/14.
//

import Foundation
import Moya

import RxSwift

final class DefaultGPTRepository: GPTRepository {
    let router: MoyaProvider<GPTService>

    init() {
        self.router = MoyaProvider<GPTService>(plugins: [NetworkLogPlugin()])
    }

    func chat(content: String) -> Observable<NetworkResult<ChatMessage>> {
        return router.rx.request(.postContent(content))
            .asObservable()
            .map { response in
                let decodedResponse: NetworkResult<GPTChatCompletionResponse> = NetworkHandler.requestDecoded(by: response)

                switch decodedResponse {
                case let .success(response):
                    return .success(response.toDomain())

                case let .failure(error):
                    return .failure(error)
                }
            }
    }
}
