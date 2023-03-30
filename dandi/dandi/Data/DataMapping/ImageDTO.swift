//
//  PostImageDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

struct PostImageDTO: Decodable {
    let postImageUrl: String
}

struct ProfileImageDTO: Decodable {
    let profileImageUrl: String
}

struct ClothesImageDTO: Decodable {
    let clothesImageUrl: String
}
