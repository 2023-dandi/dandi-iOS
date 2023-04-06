//
//  ClothesDetailInfoDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/04.
//

struct ClothesDetailInfoDTO: Decodable {
    let id: Int
    let clothesImageURL: String
    let category: ClothesCategoryDTO
    let seasons: [SeasonDTO]

    enum CodingKeys: String, CodingKey {
        case id
        case clothesImageURL = "clothesImageUrl"
        case category, seasons
    }
}

extension ClothesDetailInfoDTO {
    func toDomain() -> ClothesDetailInfo {
        return ClothesDetailInfo(
            id: id,
            imageURL: clothesImageURL,
            category: category.toDomain(),
            seasons: seasons.map { $0.toDomain() }
        )
    }
}
