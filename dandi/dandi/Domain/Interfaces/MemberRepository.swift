//
//  MemberRepository.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/20.
//


protocol MemberRepository {
    func updateProfileImage(
        id: Int,
        completion: @escaping NetworkCompletion<PostDTO>
    )

    func updateNickname(
        id: Int,
        completion: @escaping NetworkCompletion<PostDTO>
    )

    func updateLocation(
        id: Int,
        completion: @escaping NetworkCompletion<PostDTO>
    )

    func fetchMemberInfo(
        completion: @escaping NetworkCompletion<PostDTO>
    )

    func confirmNicknameDuplication(
        completion: @escaping NetworkCompletion<PostDTO>
    )
}
