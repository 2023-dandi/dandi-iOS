//
//  MemberInfoDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

struct MemberInfoDTO: Decodable {
    let nickname: String
    let latitude: Double
    let longitude: Double
    let profileImageUrl: String
}
