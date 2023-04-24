//
//  MemberRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import Foundation

import RxSwift

protocol MemberRepository {
    func updateProfileImage(
        imageData: Data,
        completion: @escaping NetworkCompletion<String>
    )

    func updateNickname(
        nickname: String,
        completion: @escaping NetworkCompletion<StatusCase>
    )

    func updateLocation(
        latitude: Double,
        longitude: Double,
        completion: @escaping NetworkCompletion<StatusCase>
    )

    func fetchMemberInfo(
        completion: @escaping NetworkCompletion<UserProfile>
    )

    func confirmNicknameDuplication(
        nickname: String,
        completion: @escaping NetworkCompletion<Bool>
    )

    func blockUser(userID: Int) -> Single<NetworkResult<StatusCase>>
}
