//
//  DecorationMenuCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

final class DecorationMenuCollectionViewCell: UICollectionViewCell {
    private let closetTabView = ClosetTabView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        render()
    }

    func update(
        category: [String],
        tagList: [String],
        photo: [UIImage]
    ) {
        closetTabView.update(category: category, tagList: tagList, photo: photo)
    }

    private func render() {
        contentView.addSubview(closetTabView)
        closetTabView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
