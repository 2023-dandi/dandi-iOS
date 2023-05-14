//
//  DefaultChatUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/05/14.
//

import RxCocoa
import RxSwift

final class DefaultChatUseCase: ChatUseCase {
    private let gptRepository: GPTRepository

    init(gptRepository: GPTRepository) {
        self.gptRepository = gptRepository
    }

    func chat(content: String) -> Observable<ChatMessage?> {
        return gptRepository.chat(content: content)
            .map { result in
                switch result {
                case let .success(message):
                    return message
                case .failure:
                    return nil
                }
            }
    }
}
