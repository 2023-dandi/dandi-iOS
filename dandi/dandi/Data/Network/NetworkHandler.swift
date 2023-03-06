//
//  NetworkHandler.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/03.
//

import Foundation

import Moya
import RxSwift

enum NetworkHandler {
    static func requestDecoded<T: Decodable>(by response: Response) -> Single<Result<T, NetworkError>> {
        let decoder = JSONDecoder()
        switch response.statusCode {
        case 200 ..< 300:
            guard let decodedData = try? decoder.decode(T.self, from: response.data) else {
                return .just(.failure(.decodedErr))
            }
            return .just(.success(decodedData))
        case 300 ..< 500:
            guard let errorResponse = try? decoder.decode(MessageDTO.self, from: response.data) else {
                return .just(.failure(.pathErr))
            }
            dump(errorResponse)
            return .just(.failure(.requestErr(errorResponse)))
        default:
            return .just(.failure(.networkFail))
        }
    }
}
