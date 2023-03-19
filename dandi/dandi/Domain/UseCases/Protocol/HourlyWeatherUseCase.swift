//
//  HourlyWeatherUseCase.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import RxCocoa
import RxSwift

protocol HoulryWeatherUseCase {
    var hourlyWeather: PublishRelay<[TimeWeatherInfo]> { get }
    var isCompleted: PublishSubject<Bool> { get }

    /// 날씨정보 가져오기
    func fetchWeatherInfo(
        nx: Int, // 그리드 x 좌표
        ny: Int, // 그리드 y 좌표
        page: Int // page 수
    )
}
