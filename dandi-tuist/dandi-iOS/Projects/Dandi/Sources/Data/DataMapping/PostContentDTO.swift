//
//  PostContentDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

import Foundation

struct PostContentDTO: Codable {
    let id: Int?
    let mine: Bool?
    let liked: Bool?
    let temperatures: TemperaturesDTO
    let createdAt: String?
    let postImageURL: String
    let outfitFeelings: OutfitFeelingsDTO
    let writer: WriterDTO?

    init(
        id: Int? = nil,
        mine: Bool? = nil,
        writer: WriterDTO? = nil,
        postImageURL: String,
        temperatures: TemperaturesDTO,
        outfitFeelings: OutfitFeelingsDTO,
        createdAt: String? = nil,
        liked: Bool? = nil
    ) {
        self.id = id ?? -1
        self.mine = mine
        self.writer = writer
        self.postImageURL = postImageURL
        self.temperatures = temperatures
        self.outfitFeelings = outfitFeelings
        self.createdAt = createdAt
        self.liked = liked
    }

    enum CodingKeys: String, CodingKey {
        case id
        case mine, temperatures, createdAt
        case postImageURL = "postImageUrl"
        case outfitFeelings, writer
        case liked
    }
}

// MARK: - WriterDTO

struct WriterDTO: Codable {
    let id: Int
    let nickname: String
    let profileImageURL: String

    enum CodingKeys: String, CodingKey {
        case id, nickname
        case profileImageURL = "profileImageUrl"
    }
}

extension PostContentDTO {
    func toDomain(id: Int) -> Post {
        return Post(
            id: id,
            mainImageURL: postImageURL,
            profileImageURL: writer?.profileImageURL,
            nickname: writer?.nickname ?? "",
            date: createdAt ?? "",
            content: "\(temperatures.min)도~\(temperatures.max)도에, \(ClothesFeeling(rawValue: outfitFeelings.feelingIndex)?.text ?? "").",
            tag: outfitFeelings.additionalFeelingIndices?.compactMap { WeatherFeeling(rawValue: $0) } ?? [],
            isLiked: liked ?? false,
            isMine: mine ?? false
        )
    }

    func toDomain() -> Post {
        return Post(
            id: id ?? -1,
            mainImageURL: postImageURL,
            profileImageURL: writer?.profileImageURL,
            nickname: writer?.nickname ?? "",
            date: createdAt ?? "",
            content: "\(temperatures.min)도~\(temperatures.max)도에, \(ClothesFeeling(rawValue: outfitFeelings.feelingIndex)?.text ?? "").",
            tag: outfitFeelings.additionalFeelingIndices?.compactMap { WeatherFeeling(rawValue: $0) } ?? [],
            isLiked: liked ?? false,
            isMine: mine ?? false
        )
    }
}

struct TemperaturesDTO: Codable {
    let min: Int
    let max: Int
    let description: String?

    init(min: Int, max: Int, description: String? = nil) {
        self.min = min
        self.max = max
        self.description = description
    }
}

extension TemperaturesDTO: Equatable {
    static func == (lhs: TemperaturesDTO, rhs: TemperaturesDTO) -> Bool {
        return lhs.min == rhs.min || lhs.max == rhs.max
    }
}

struct OutfitFeelingsDTO: Codable {
    let feelingIndex: Int
    let additionalFeelingIndices: [Int]?
}
