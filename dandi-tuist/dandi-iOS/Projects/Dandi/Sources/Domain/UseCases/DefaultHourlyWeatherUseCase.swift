//
//  DefaultHourlyWeatherUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/06.
//

import Foundation
import RxCocoa
import RxSwift

final class DefaultHourlyWeatherUseCase: HoulryWeatherUseCase {
    let hourlyWeather = PublishRelay<TodayWeatherInfo>()
    let isCompleted = PublishSubject<Bool>()

    private let weatherRepository: WeatherRepository
    private let disposeBag = DisposeBag()

    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }

    func fetchWeatherInfo(
        nx: Int,
        ny: Int,
        page: Int
    ) {
        let (base_date, baseTime) = TimeConverter().getBaseDateAndBaseTime()
        weatherRepository.fetchWeather(
            numOfRows: 280,
            page: page,
            base_date: base_date,
            base_time: baseTime,
            nx: nx,
            ny: ny
        ) { [weak self] result in
            switch result {
            case let .success(response):
                self?.hourlyWeather.accept(response)
                self?.isCompleted.onNext(true)
            case .failure:
                self?.isCompleted.onNext(false)
            }
        }
    }
}
