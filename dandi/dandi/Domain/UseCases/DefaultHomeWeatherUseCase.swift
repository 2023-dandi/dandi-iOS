//
//  DefaultHomeWeatherUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/06.
//

import RxCocoa
import RxSwift

protocol HoulryWeatherUseCase {
    var hourlyWeather: PublishRelay<[TimeWeatherInfo]> { get }
    func fetchWeatherInfo()
}

final class DefaultHomeWeatherUseCase: HoulryWeatherUseCase {
    let hourlyWeather = PublishRelay<[TimeWeatherInfo]>()

    private let weatherRepository: WeatherRepository
    private let disposeBag = DisposeBag()

    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }

    func fetchWeatherInfo() {
        weatherRepository.fetchTodayWeather(
            numOfRows: 100,
            page: 1,
            base_date: "20230305",
            base_time: "0500",
            nx: 55,
            ny: 127
        ) { [weak self] result in
            switch result {
            case let .success(response):
                self?.hourlyWeather.accept(response.toDomain())
                dump(response.toDomain())
            case let .failure(error):
                dump(error)
            }
        }
    }
}
