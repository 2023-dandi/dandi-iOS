//
//  DefaultMemberRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import Foundation

import Moya

final class DefaultMemberRepository: MemberRepository {
    let router: MoyaProvider<MemberService>

    init(interceptor: Interceptor) {
        self.router = MoyaProvider<MemberService>(
            session: Session(interceptor: interceptor),
            plugins: [NetworkLogPlugin()]
        )
    }

    func updateProfileImage(
        imageData: Data,
        completion: @escaping NetworkCompletion<String>
    ) {
        router.request(.putProfileImage(imageData)) { result in
            switch result {
            case let .success(response):
                let decodedResponse: NetworkResult<ProfileImageDTO> = NetworkHandler.requestDecoded(by: response)

                switch decodedResponse {
                case let .success(imageDTO):
                    completion(.success(imageDTO.profileImageUrl))

                case let .failure(error):
                    completion(.failure(error))
                }

            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func updateNickname(
        nickname: String,
        completion: @escaping NetworkCompletion<StatusCase>
    ) {
        router.request(.patchNickname(nickname: nickname)) { result in
            switch result {
            case let .success(response):
                completion(NetworkHandler.requestStatusCaseDecoded(by: response))
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func updateLocation(
        latitude: Double,
        longitude: Double,
        completion: @escaping NetworkCompletion<StatusCase>
    ) {
        router.request(.patchLocation(latitude: latitude, longitude: longitude)) { result in
            switch result {
            case let .success(response):
                completion(NetworkHandler.requestStatusCaseDecoded(by: response))
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func fetchMemberInfo(completion: @escaping NetworkCompletion<UserProfile>) {
        router.request(.getMemberInfo) { result in
            switch result {
            case let .success(response):
                let decodedResponse: NetworkResult<MemberInfoDTO> = NetworkHandler.requestDecoded(by: response)

                switch decodedResponse {
                case let .success(memberInfoDTO):
                    // TODO: 추후 리팩토링
                    completion(.success(memberInfoDTO.toDomain(location: UserDefaultHandler.shared.address)))
                case let .failure(error):
                    completion(.failure(error))
                }
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func confirmNicknameDuplication(
        nickname: String,
        completion: @escaping NetworkCompletion<Bool>
    ) {
        router.request(.confirmNicknameDulication(nickname: nickname)) { result in
            switch result {
            case let .success(response):
                let decodedResponse: NetworkResult<DuplicationDTO> = NetworkHandler.requestDecoded(by: response)

                switch decodedResponse {
                case let .success(duplicationDTO):
                    completion(.success(duplicationDTO.duplicated))

                case let .failure(error):
                    completion(.failure(error))
                }
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }
}
