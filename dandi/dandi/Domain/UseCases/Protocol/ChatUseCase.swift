//
//  ChatUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/05/14.
//

import RxCocoa
import RxSwift

protocol ChatUseCase {
    func chat(content: String) -> Observable<ChatMessage?>
}
