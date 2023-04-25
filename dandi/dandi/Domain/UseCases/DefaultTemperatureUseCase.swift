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
        if UserDefaultHandler.shared.min != -1000, UserDefaultHandler.shared.max != -1000 {
            DispatchQueue.main.async {
                self.temperatureInfo.accept(
                    Temperatures(
                        min: UserDefaultHandler.shared.min,
                        max: UserDefaultHandler.shared.max
                    )
                )
            }

            return
        }

        let (base_date, baseTime) = TimeConverter.shared.getBaseDateAndBaseTime()
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
                UserDefaultHandler.shared.min = response.temperatures.min
                UserDefaultHandler.shared.max = response.temperatures.max
                self?.temperatureInfo.accept(response.temperatures)
            case .failure:
                self?.temperatureInfo.accept(nil)
            }
        }
    }
}
