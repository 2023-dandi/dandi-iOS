//
//  MessageDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/03.
//

struct MessageDTO: Decodable, Error {
    let message: String?
}

extension MessageDTO {
    func toDomain(statusCode: Int) -> ErrorResponse {
        return ErrorResponse(statusCase: StatusCase(statusCode), message: message)
    }
}
