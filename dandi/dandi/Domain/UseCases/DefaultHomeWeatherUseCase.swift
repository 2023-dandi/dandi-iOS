//
//  DefaultHomeWeatherUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/06.
//

import RxCocoa
import RxSwift

protocol HomeWeatherUseCase {}

final class DefaultHomeWeatherUseCase: HomeWeatherUseCase {
    private let weatherRepository: WeatherRepository
    private let disposeBag = DisposeBag()

    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }

    func fetchWeatherInfo() {
        weatherRepository.fetchTodayWeather(
            numOfRows: 10,
            page: 1,
            base_date: "20230305",
            base_time: "0500",
            nx: 55,
            ny: 127
        ).subscribe { response in
            dump(response)
        }.disposed(by: disposeBag)
    }
}
