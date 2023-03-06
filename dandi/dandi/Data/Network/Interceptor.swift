//
//  Interceptor.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/03.
//

import Foundation

import Alamofire
import Moya
import RxSwift

final class Interceptor: RequestInterceptor {
    private var retryLimit = 2

    func adapt(
        _ urlRequest: URLRequest,
        for _: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var urlRequest = urlRequest
        urlRequest.setValue(
            "Bearer " + KeychainHandler.shared.accessToken,
            forHTTPHeaderField: "Authorization"
        )
        completion(.success(urlRequest))
    }

    func retry(
        _ request: Request,
        for _: Session,
        dueTo _: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard
            let statusCode = request.response?.statusCode,
            request.retryCount < retryLimit,
            statusCode == 401
        else {
            return completion(.doNotRetry)
        }

        refreshToken { isSuccess in
            isSuccess ? completion(.retry) : completion(.doNotRetry)
        }
    }

    private func refreshToken(completion: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(KeychainHandler.shared.accessToken)",
            "Cookie": "Refresh-Token=\(KeychainHandler.shared.refreshToken)"
        ]

        let dataTask = AF.request(
            Environment.baseURL + "/refresh",
            method: .post,
            encoding: JSONEncoding.default,
            headers: headers
        )

        dataTask.responseData { responseData in
            switch responseData.result {
            case .success:
                // Authorization, Set-Cookie Header로 오는거 파싱
                dump(responseData.response?.allHeaderFields)
                completion(true)
            case .failure:
                KeychainHandler.shared.refreshToken = ""
                KeychainHandler.shared.accessToken = ""
                RootSwitcher.update(.login)
                completion(false)
            }
        }
    }
}