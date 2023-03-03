//
//  NetworkError.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/03.
//

enum NetworkError: Error {
    case requestErr(MessageDTO)
    case decodedErr
    case pathErr
    case networkFail
}
