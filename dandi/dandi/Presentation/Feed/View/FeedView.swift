//
//  FeedView.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/04.
//

import UIKit

import SnapKit
import Then
import YDS

final class FeedView: UIView {
    private let navigationBar: UIView = .init()
    private(set) lazy var navigationTitleLabel: UILabel = .init()
    private(set) lazy var locationButton: UIButton = .init()

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(318 / 375)
            )

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 2
            )
            group.interItemSpacing = .fixed(10)
            group.contentInsets = .init(top: .zero, leading: 12, bottom: .zero, trailing: 12)

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
        collectionView.delegate = self
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

extension FeedView {
    private func setLayouts() {
        navigationBar.addSubviews(navigationTitleLabel, locationButton)
        addSubviews(navigationBar, collectionView)
        navigationBar.snp.makeConstraints { make in
            make.height.equalTo(108)
            make.leading.top.trailing.equalTo(safeAreaLayoutGuide)
        }
        navigationTitleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(16)
        }
        locationButton.snp.makeConstraints { make in
            make.top.equalTo(navigationTitleLabel.snp.bottom)
            make.trailing.equalTo(navigationTitleLabel.snp.trailing)
            make.height.equalTo(24)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.bottom.trailing.equalTo(safeAreaLayoutGuide)
        }
    }

    private func setProperties() {
        navigationBar.do {
            $0.backgroundColor = YDSColor.bgNormal
            $0.clipsToBounds = true
        }
        navigationTitleLabel.do {
            $0.font = YDSFont.title3
            $0.numberOfLines = 0
        }

        var attString = AttributedString("위치 수정")
        attString.font = YDSFont.button4
        attString.foregroundColor = YDSColor.buttonNormal

        var config = UIButton.Configuration.plain()
        config.attributedTitle = attString
        config.image = YDSIcon.warningcircleLine.withTintColor(
            YDSColor.buttonNormal,
            renderingMode: .alwaysOriginal
        ).resize(newWidth: 16)
        config.titleAlignment = .leading
        config.imagePadding = 2
        config.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        locationButton.configuration = config
    }
}

extension FeedView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewTranslationY = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let height = scrollViewTranslationY < 0 ? 45 : 108
        let navigationTitle = scrollViewTranslationY < 0
            ? "상도동 18도"
            : "현재 상도동은 18도입니다.\n가디건을 걸치고 나가면 어떨까요?"
        navigationTitleLabel.text = navigationTitle
        layoutIfNeeded()
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.navigationBar.snp.updateConstraints {
                $0.height.equalTo(height)
            }
            self.layoutIfNeeded()
        }
    }
}
