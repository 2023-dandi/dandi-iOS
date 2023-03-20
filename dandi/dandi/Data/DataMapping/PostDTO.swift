//
//  PostDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

import Foundation

struct PostDTO: Codable {
    let mine: Bool?
    let liked: Bool?
    let temperatures: Temperatures
    let createdAt: String?
    let postImageURL: String
    let outfitFeelings: OutfitFeelings
    let writer: Writer?

    init(
        mine: Bool? = nil,
        writer: Writer? = nil,
        postImageURL: String,
        temperatures: Temperatures,
        outfitFeelings: OutfitFeelings,
        createdAt: String? = nil,
        liked: Bool? = nil
    ) {
        self.mine = mine
        self.writer = writer
        self.postImageURL = postImageURL
        self.temperatures = temperatures
        self.outfitFeelings = outfitFeelings
        self.createdAt = createdAt
        self.liked = liked
    }

    enum CodingKeys: String, CodingKey {
        case mine, temperatures, createdAt
        case postImageURL = "postImageUrl"
        case outfitFeelings, writer
        case liked
    }
}

// MARK: - Writer

struct Writer: Codable {
    let id: Int
    let nickname: String
    let profileImageURL: String

    enum CodingKeys: String, CodingKey {
        case id, nickname
        case profileImageURL = "profileImageUrl"
    }
}

extension PostDTO {
    func toDomain(id: Int) -> Post {
        return Post(
            id: id,
            mainImageURL: postImageURL,
            profileImageURL: nil,
            nickname: writer?.nickname ?? "",
            date: createdAt ?? "",
            content: "\(temperatures.min)도~\(temperatures.max)도에, \(ClothesFeeling(rawValue: outfitFeelings.feelingIndex)?.text ?? "").",
            tag: outfitFeelings.additionalFeelingIndices?.compactMap { WeatherFeeling(rawValue: $0) } ?? [],
            isLiked: liked ?? false,
            isMine: mine ?? false
        )
    }
}

struct Temperatures: Codable {
    let min: Int
    let max: Int
    let description: String?

    init(min: Int, max: Int, description: String? = nil) {
        self.min = min
        self.max = max
        self.description = description
    }
}

extension Temperatures: Equatable {
    static func == (lhs: Temperatures, rhs: Temperatures) -> Bool {
        return lhs.min == rhs.min || lhs.max == rhs.max
    }
}

struct OutfitFeelings: Codable {
    let feelingIndex: Int
    let additionalFeelingIndices: [Int]?
}
