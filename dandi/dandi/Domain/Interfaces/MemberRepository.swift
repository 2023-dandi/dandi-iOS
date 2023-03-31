//
//  MemberRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//

import UIKit

protocol MemberRepository {
    func updateProfileImage(
        image: UIImage,
        completion: @escaping NetworkCompletion<ProfileImageDTO>
    )

    func updateNickname(
        nickname: String,
        completion: @escaping NetworkCompletion<StatusCase>
    )

    func updateLocation(
        latitude: Double,
        longitude: Double,
        completion: @escaping NetworkCompletion<Location>
    )

    func fetchMemberInfo(
        completion: @escaping NetworkCompletion<MemberInfoDTO>
    )

    func confirmNicknameDuplication(
        nickname: String,
        completion: @escaping NetworkCompletion<DuplicationDTO>
    )
}
