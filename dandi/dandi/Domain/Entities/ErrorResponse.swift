//
//  ErrorResponse.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import Foundation

struct ErrorResponse {
    let statusCase: StatusCase
    let message: String?

    init(statusCase: StatusCase, message: String?) {
        self.statusCase = statusCase
        self.message = message
    }

    init(statusCode: Int) {
        self.init(statusCase: StatusCase(statusCode), message: nil)
    }
}
