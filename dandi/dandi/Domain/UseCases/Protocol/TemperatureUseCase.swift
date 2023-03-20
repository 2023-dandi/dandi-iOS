//
//  TemperatureUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import RxCocoa
import RxSwift

protocol TemperatureUseCase {
    var temperatureInfo: PublishRelay<Temperatures?> { get }
    func fetchWeatherInfo(
        nx: Int, // 그리드 x 좌표
        ny: Int, // 그리드 y 좌표
        page: Int // page 수
    )
}
