//
//  DefaultWeatherRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/06.
//

import Alamofire
import Foundation
import Moya
import RxMoya
import RxSwift

final class DefaultWeatherRepository: WeatherRepository {
    private let weatherService: WeatherService

    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }

    func fetchTodayWeather(
        numOfRows: Int,
        page: Int,
        base_date: String,
        base_time: String,
        nx: Int,
        ny: Int
    ) -> Observable<WeatherDTO> {
        return Observable<WeatherDTO>.create { [weak self] observer in
            self?.weatherService.getWeathers(
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
                    observer.onNext(response)
                case let .failure(error):
                    dump(error)
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
