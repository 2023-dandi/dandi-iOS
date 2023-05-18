//
//  GPTRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/05/14.
//

import Foundation

import RxSwift

protocol GPTRepository {
    func chat(content: String) -> Observable<NetworkResult<ChatMessage>>
}
