//
//  PostDetailView.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/10.
//

import UIKit

import Then
import YDS

final class PostDetailView: UIView {}

private final class ProfileView: UIView {
    private let contentView: UIStackView = .init()
    private let imageView: YDSProfileImageView = .init()
    private let nicknameLabel: UILabel = .init()
    private let timeLabel: UILabel = .init()

    private func setProperties() {
        contentView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }

        imageView.do {
            $0.size = .medium
        }
    }

    private func setLayouts() {}
}
