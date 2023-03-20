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
                return .just(.failure(.decodedError))
            }
            return .just(.success(decodedData))
        case 300 ..< 500:
            guard let message = try? decoder.decode(MessageDTO.self, from: response.data) else {
                return .just(.failure(.httpError(ErrorResponse(statusCode: response.statusCode))))
            }
            return .just(.failure(.httpError(message.toDomain(statusCode: response.statusCode))))
        default:
            return .just(.failure(.networkFail))
        }
    }

    static func requestDecoded<T: Decodable>(by response: Response) -> NetworkResult<T> {
        let decoder = JSONDecoder()
        switch response.statusCode {
        case 200 ..< 300:
            guard let decodedData = try? decoder.decode(T.self, from: response.data) else {
                return .failure(.decodedError)
            }
            return .success(decodedData)
        case 300 ..< 500:
            guard let message = try? decoder.decode(MessageDTO.self, from: response.data) else {
                return .failure(.httpError(ErrorResponse(statusCode: response.statusCode)))
            }
            return .failure(.httpError(message.toDomain(statusCode: response.statusCode)))
        default:
            return .failure(.networkFail)
        }
    }

    static func requestErrorDecoded(by response: Response) -> NetworkResult<StatusCase> {
        let decoder = JSONDecoder()
        switch response.statusCode {
        case 200 ..< 300:
            return .success(StatusCase(response.statusCode))
        case 300 ..< 500:
            guard let message = try? decoder.decode(MessageDTO.self, from: response.data) else {
                return .failure(.httpError(ErrorResponse(statusCode: response.statusCode)))
            }
            return .failure(.httpError(message.toDomain(statusCode: response.statusCode)))
        default:
            return .failure(.networkFail)
        }
    }
}
