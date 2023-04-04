//
//  DefaultClothesRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/30.
//

import Foundation
import Moya

import RxSwift

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
            case .failure:
                completion(.failure(.networkFail))
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
                completion(NetworkHandler.requestStatusCaseDecoded(by: response))
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func fetchList(
        size: Int,
        page: Int,
        category: String,
        seasons: [String],
        completion: @escaping NetworkCompletion<ListWithPage<Clothes>>
    ) {
        router.request(.getClothesList(size: size, page: page, category: category, seasons: seasons)) { result in
            switch result {
            case let .success(response):
                let decodedResponse: NetworkResult<ClothesWithPageDTO> = NetworkHandler.requestDecoded(by: response)

                switch decodedResponse {
                case let .success(clothesDTO):
                    completion(.success(clothesDTO.toDomain()))

                case let .failure(error):
                    completion(.failure(error))
                }
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func fetchCategory() -> Single<NetworkResult<[CategoryInfo]>> {
        return router.rx.request(.getClothesCategory)
            .map { response in
                let decodedResponse: NetworkResult<ClothesCategoryListDTO> = NetworkHandler.requestDecoded(by: response)
                switch decodedResponse {
                case let .success(category):
                    return .success(category.toDomain())

                case let .failure(error):
                    return .failure(error)
                }
            }
    }
}
