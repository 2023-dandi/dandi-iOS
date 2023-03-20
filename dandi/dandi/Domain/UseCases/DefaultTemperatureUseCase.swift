//
//  DefaultTemperatureUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

import Foundation
import RxCocoa
import RxSwift

final class DefaultTemperatureUseCase: TemperatureUseCase {
    let temperatureInfo = PublishRelay<Temperatures?>()
    let isCompletedUpdationLocation = PublishSubject<Bool>()

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
            numOfRows: 500,
            page: page,
            base_date: base_date,
            base_time: baseTime,
            nx: nx,
            ny: ny
        ) { [weak self] result in
            switch result {
            case let .success(response):
                self?.temperatureInfo.accept(response.toDomain())
            case .failure:
                self?.temperatureInfo.accept(nil)
            }
        }
    }
}
