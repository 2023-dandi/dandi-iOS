//
//  DefaultClothesRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/30.
//

import Foundation
import Moya

final class DefaultClothesRepository: ClothesRepository {
    private let router: MoyaProvider<ClothesService>

    init(interceptor: Interceptor) {
        self.router = MoyaProvider<ClothesService>(
            session: Session(interceptor: interceptor),
            plugins: [NetworkLogPlugin()]
        )
    }

    func upload(
        category: String,
        seasons: [String],
        clothesImageURL: String,
        completion: @escaping NetworkCompletion<StatusCase>
    ) {
        router.request(.postClothes(category: category, seasons: seasons, clothesImageURL: clothesImageURL)) { result in
            switch result {
            case let .success(response):
                return completion(NetworkHandler.requestStatusCaseDecoded(by: response))
            case .failure:
                return completion(.failure(.networkFail))
            }
        }
    }

    func uploadImage(
        imageData: Data,
        completion: @escaping NetworkCompletion<String>
    ) {
        router.request(.postClothesImage(imageData: imageData)) { result in
            switch result {
            case let .success(response):
                let decodedResponse: NetworkResult<ClothesImageDTO> = NetworkHandler.requestDecoded(by: response)

                switch decodedResponse {
                case let .success(clothesImageDTO):
                    completion(.success(clothesImageDTO.clothesImageUrl))

                case let .failure(error):
                    completion(.failure(error))
                }

                return completion(NetworkHandler.requestDecoded(by: response))
            case .failure:
                return completion(.failure(.networkFail))
            }
        }
    }

    func delete(
        clothesID: Int,
        completion: @escaping NetworkCompletion<StatusCase>
    ) {
        router.request(.deleteClothes(clothesID: clothesID)) { result in
            switch result {
            case let .success(response):
                return completion(NetworkHandler.requestStatusCaseDecoded(by: response))
            case .failure:
                return completion(.failure(.networkFail))
            }
        }
    }
}
