//
//  WeatherRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/06.
//

import RxSwift

protocol WeatherRepository {
    /// 날씨 조회
    func fetchTodayWeather(
        numOfRows: Int,
        page: Int,
        base_date: String,
        base_time: String,
        nx: Int,
        ny: Int,
        completion: @escaping (NetworkResult<WeatherDTO>) -> Void
    )
}
