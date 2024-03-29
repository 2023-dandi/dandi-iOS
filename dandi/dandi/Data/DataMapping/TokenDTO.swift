//
//  TokenDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/04.
//

struct TokenDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}

extension TokenDTO {
    func toDomain() -> Token {
        return Token(accessToken: accessToken, refreshToken: refreshToken)
    }
}
