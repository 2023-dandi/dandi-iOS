//
//  NetworkResult.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/04.
//

import RxSwift

typealias NetworkResult<Success> = Single<Result<Success, NetworkError>>
