//
//  DefaultWeatherRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/06.
//

import Alamofire
import Foundation

final class DefaultWeatherRepository: WeatherRepository {
    private let weatherService: WeatherService

    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }

    func fetchWeather(
        numOfRows: Int,
        page: Int,
        base_date: String,
        base_time: String,
        nx: Int,
        ny: Int,
        completion: @escaping (NetworkResult<TodayWeatherInfo>) -> Void
    ) {
        weatherService.getWeathers(
            numOfRows: numOfRows,
            page: page,
            base_date: base_date,
            base_time: base_time,
            nx: nx,
            ny: ny
        ) { result in
            switch result {
            case let .success(response):
                dump(response)
                completion(.success(response.toDomain()))
            case let .failure(error):
                completion(.failure(.error(error)))
            }
        }
    }
}
