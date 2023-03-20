//
//  DefaultMemberRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import UIKit

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
        image: UIImage,
        completion: @escaping NetworkCompletion<ProfileImageDTO>
    ) {
        router.request(.putProfileImage(image)) { result in
            switch result {
            case let .success(response):
                completion(NetworkHandler.requestDecoded(by: response))
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
                completion(NetworkHandler.requestErrorDecoded(by: response))
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func updateLocation(
        latitude: Double,
        longitude: Double,
        completion: @escaping NetworkCompletion<LocationDTO>
    ) {
        router.request(.patchLocation(latitude: latitude, longitude: longitude)) { result in
            switch result {
            case let .success(response):
                completion(NetworkHandler.requestDecoded(by: response))
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func fetchMemberInfo(completion: @escaping NetworkCompletion<MemberInfoDTO>) {
        router.request(.getMemberInfo) { result in
            switch result {
            case let .success(response):
                completion(NetworkHandler.requestDecoded(by: response))
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }

    func confirmNicknameDuplication(
        nickname: String,
        completion: @escaping NetworkCompletion<DuplicationDTO>
    ) {
        router.request(.confirmNicknameDulication(nickname: nickname)) { result in
            switch result {
            case let .success(response):
                completion(NetworkHandler.requestDecoded(by: response))
            case .failure:
                completion(.failure(.networkFail))
            }
        }
    }
}
