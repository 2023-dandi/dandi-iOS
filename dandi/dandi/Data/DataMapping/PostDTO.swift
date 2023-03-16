//
//  PostDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

import Foundation

struct PostDTO: Codable {
    let writerNickname: String?
    let postImageUrl: String
    let temperatures: TemperatureInfo
    let outfitFeelings: OutfitFeelingsInfo
    let createdAt: String?

    init(
        writerNickname: String? = nil,
        postImageUrl: String,
        temperatures: TemperatureInfo,
        outfitFeelings: OutfitFeelingsInfo,
        createdAt: String? = nil
    ) {
        self.writerNickname = writerNickname
        self.postImageUrl = postImageUrl
        self.temperatures = temperatures
        self.outfitFeelings = outfitFeelings
        self.createdAt = createdAt
    }
}

struct TemperatureInfo: Codable {
    let min: Int
    let max: Int
    let description: String?

    init(min: Int, max: Int, description: String? = nil) {
        self.min = min
        self.max = max
        self.description = description
    }
}

struct OutfitFeelingsInfo: Codable {
    let feelingIndex: Int
    let additionalFeelingIndices: [Int]
}
