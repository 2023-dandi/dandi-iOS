//
//  DefaultHourlyWeatherUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/06.
//

import Foundation
import RxCocoa
import RxSwift

protocol HoulryWeatherUseCase {
    var hourlyWeather: PublishRelay<[TimeWeatherInfo]> { get }
    var isCompletedUpdationLocation: PublishSubject<Bool> { get }
    func fetchWeatherInfo(
        nx: Int, // 그리드 x 좌표
        ny: Int, // 그리드 y 좌표
        page: Int // page 수
    )
}

final class DefaultHourlyWeatherUseCase: HoulryWeatherUseCase {
    let hourlyWeather = PublishRelay<[TimeWeatherInfo]>()
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
            numOfRows: 280,
            page: page,
            base_date: base_date,
            base_time: baseTime,
            nx: nx,
            ny: ny
        ) { [weak self] result in
            switch result {
            case let .success(response):
                self?.hourlyWeather.accept(response.toDomain())
                self?.isCompletedUpdationLocation.onNext(true)
            case .failure:
                self?.isCompletedUpdationLocation.onNext(false)
            }
        }
    }
}
