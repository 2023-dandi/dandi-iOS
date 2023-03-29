//
//  PostContentDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/17.
//

struct PostDTO: Decodable {
    let id: Int
    let writer: Writer
    let liked: Bool
    let temperatures: Temperatures
    let feelingIndex: Int
    let postImageUrl: String
    let createdAt: String
}

extension PostDTO {
    func toDomain() -> Post {
        return Post(
            id: id,
            mainImageURL: postImageUrl,
            profileImageURL: writer.profileImageURL,
            nickname: writer.nickname,
            date: createdAt,
            content: "\(temperatures.min)도~\(temperatures.max)도에, \(ClothesFeeling(rawValue: feelingIndex)?.text ?? "").",
            tag: [],
            isLiked: liked,
            isMine: nil
        )
    }
}
