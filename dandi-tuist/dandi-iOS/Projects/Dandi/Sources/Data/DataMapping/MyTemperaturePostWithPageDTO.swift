//
//  MyTemperaturePostWithPageDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/29.
//

import Foundation

struct MyTemperaturePostWithPageDTO: Decodable {
    let posts: [MyTemperaturePostDTO]
    let writer: WriterDTO
    let lastPage: Bool
}

struct MyTemperaturePostDTO: Decodable {
    let id, feelingIndex: Int
    let postImageURL: String
    let liked: Bool
    let temperatures: TemperaturesDTO?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, feelingIndex
        case postImageURL = "postImageUrl"
        case liked, createdAt
        case temperatures
    }
}

extension MyTemperaturePostWithPageDTO {
    func toDomain() -> ListWithPage<Post> {
        let posts = posts.map {
            Post(
                id: $0.id,
                mainImageURL: $0.postImageURL,
                profileImageURL: writer.profileImageURL,
                nickname: writer.nickname,
                date: $0.createdAt ?? "",
                content: "\($0.temperatures?.min ?? 0)도/\($0.temperatures?.max ?? 0)도에, \(ClothesFeeling(rawValue: $0.feelingIndex)?.text ?? "").",
                tag: [],
                isLiked: $0.liked,
                isMine: true
            )
        }
        return ListWithPage<Post>(list: posts, lastPage: lastPage)
    }
}
