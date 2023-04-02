//
//  ClothesDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/02.
//

struct ClothesWithPageDTO: Decodable {
    let clothes: [ClothesDTO]
    let lastPage: Bool
}

struct ClothesDTO: Decodable {
    let id: Int
    let clothesImageUrl: String
}

extension ClothesWithPageDTO {
    func toDomain() -> ListWithPage<Clothes> {
        return ListWithPage<Clothes>(
            list: clothes.map { Clothes(id: $0.id, imageURL: $0.clothesImageUrl) },
            lastPage: lastPage
        )
    }
}
