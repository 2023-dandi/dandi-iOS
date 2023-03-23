//
//  UserProfile.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/09.
//

import Foundation

struct UserProfile {
    let uuid = UUID()
    let profileImageURL: String
    let nickname: String
    let location: String
    let closetCount: Int

    init(profileImageURL: String, nickname: String, location: String, closetCount: Int) {
        self.profileImageURL = profileImageURL
        self.nickname = nickname
        self.location = location
        self.closetCount = closetCount
    }

    init() {
        self.init(
            profileImageURL: "",
            nickname: "",
            location: "",
            closetCount: 0
        )
    }
}

extension UserProfile: Equatable, Hashable {
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
