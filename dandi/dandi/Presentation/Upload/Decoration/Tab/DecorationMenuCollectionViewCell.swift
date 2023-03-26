//
//  DecorationMenuCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

import SnapKit
import Then
import YDS

final class DecorationMenuCollectionViewCell: UICollectionViewCell {
    private let closetTabView = ClosetTabViewController()
    private let backgroundTabView = BackgroundTabViewController()
    private let stickerTabView = UIView()

    private let menuBar = UIStackView()
    private let buttons: [PagerButton] = [PagerButton("옷장"), PagerButton("배경"), PagerButton("스티커")]
    private lazy var tabs: [UIView] = [closetTabView.view, backgroundTabView.view, stickerTabView]

    override init(frame: CGRect) {
        super.init(frame: frame)

        setLayouts()
        setProperties()
    }

    func update(
        category: [String],
        tagList: [String],
        photo: [UIImage]
    ) {
        closetTabView.update(category: category, tagList: tagList, photo: photo)
    }

    private func setProperties() {
        menuBar.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.borderColor = YDSColor.borderNormal
            $0.borderWidth = YDSConstant.Border.thin
        }
        for (tag, button) in buttons.enumerated() {
            button.tag = tag
            button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        }
        for (tag, view) in tabs.enumerated() {
            view.tag = tag
        }
        buttons.first?.isSelected = true
        backgroundTabView.view.isHidden = true
        stickerTabView.isHidden = true
    }

    private func setLayouts() {
        buttons.forEach { menuBar.addArrangedSubview($0) }
        contentView.addSubviews(menuBar)
        menuBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        tabs.forEach {
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.top.equalTo(menuBar.snp.bottom)
                make.leading.bottom.trailing.equalToSuperview()
            }
        }
    }

    @objc
    private func buttonDidTap(_ button: UIButton) {
        buttons.forEach {
            $0.isSelected = $0.tag == button.tag
        }
        tabs.forEach {
            $0.isHidden = $0.tag != button.tag
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
