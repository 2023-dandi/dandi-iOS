//
//  LocationDTO.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

struct LocationDTO: Decodable {
    let latitude: Double
    let longitude: Double
}

extension LocationDTO {
    func toDomain() -> Location {
        return Location(latitude: latitude, longitude: longitude)
    }
}
