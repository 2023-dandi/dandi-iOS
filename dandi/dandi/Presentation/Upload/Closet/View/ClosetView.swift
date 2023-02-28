//
//  ClosetView.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/15.
//

import UIKit

import SnapKit
import Then
import YDS

final class ClosetView: UIView {
    private let navigationBar: YDSTopBar = .init()
    private(set) lazy var backButton = YDSTopBarButton(image: YDSIcon.arrowLeftLine)
    private(set) lazy var doneButton = YDSTopBarButton(image: YDSIcon.checkLine)
    private let navigationTitleLabel: UILabel = .init()

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.3),
                heightDimension: .fractionalWidth(0.3)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: itemSize.heightDimension
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 3
            )
            group.interItemSpacing = .fixed(2)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }()

    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: .zero, left: .zero, bottom: 16, right: .zero)
        return collectionView
    }()

    init() {
        super.init(frame: .zero)
        setLayouts()
        setProperties()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ClosetView {
    private func setLayouts() {
        navigationBar.addSubviews(navigationTitleLabel, doneButton)
        addSubviews(navigationBar, collectionView)
        navigationBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(safeAreaLayoutGuide)
        }
        navigationTitleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(16)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.bottom.trailing.equalTo(safeAreaLayoutGuide)
        }
    }

    private func setProperties() {
        navigationBar.do {
            $0.topItem?.title = "옷장"
            $0.topItem?.setRightBarButton(UIBarButtonItem(customView: doneButton), animated: true)
            $0.topItem?.setLeftBarButton(UIBarButtonItem(customView: backButton), animated: true)
        }
        navigationTitleLabel.do {
            $0.font = YDSFont.title3
            $0.numberOfLines = 0
        }
    }
}
