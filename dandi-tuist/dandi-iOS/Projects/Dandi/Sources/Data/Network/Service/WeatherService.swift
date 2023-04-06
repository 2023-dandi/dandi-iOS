//
//  WeatherService.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/06.
//

import Foundation

import Moya

protocol WeatherService {
    func getWeathers(
        numOfRows: Int,
        page: Int,
        base_date: String,
        base_time: String,
        nx: Int,
        ny: Int,
        completion: @escaping (NetworkResult<WeatherDTO>) -> Void
    )
}

final class DefaultWeatherService: WeatherService {
    func getWeathers(
        numOfRows: Int,
        page: Int,
        base_date: String,
        base_time: String,
        nx: Int,
        ny: Int,
        completion: @escaping (NetworkResult<WeatherDTO>) -> Void
    ) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let queryParams: [String: Any] = [
            "serviceKey": "sS9mlDemZwGQFvXmlknhraaS5PBNGwBDGPp0IZfmHPhFRED34lQ3MiSoUgbiBlJtymQ9WPnw3eJBkvIxdO%2Fi8w%3D%3D",
            "numOfRows": numOfRows,
            "pageNo": page,
            "dataType": "json",
            "base_date": base_date,
            "base_time": base_time,
            "nx": nx,
            "ny": ny
        ]

        var components = URLComponents()
        components.scheme = "http"
        components.host = "apis.data.go.kr"
        components.path = "/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        components.queryItems = queryParams
            .map { URLQueryItem(name: $0, value: "\($1)") }
        components.percentEncodedQuery = components.percentEncodedQuery?
            .replacingOccurrences(of: "%25", with: "%")

        guard let requestURL = components.url else {
            completion(.failure(.decodedError))
            return
        }

        dump(requestURL)

        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            guard error == nil else {
                completion(.failure(.error(error)))
                return
            }
            let successsRange = 200 ..< 300

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(.failure(.decodedError))
                return
            }

            guard successsRange.contains(statusCode) else {
                completion(.failure(.httpError(ErrorResponse(statusCode: statusCode))))
                return
            }

            guard
                let data = data,
                let decodedData = try? JSONDecoder().decode(WeatherDTO.self, from: data)
            else {
                dump(String(data: data ?? Data(), encoding: .utf8))
                completion(.failure(.decodedError))
                return
            }

            completion(.success(decodedData))
        }
        dataTask.resume()
    }
}
