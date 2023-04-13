//
//  NotificationListViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/28.
//

import UIKit

import SnapKit
import Then
import YDS

final class NotificationListViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = YDSColor.bgNormal
        return collectionView
    }()

    private let emptyLabel = EmptyLabel(text: "받은 알림이 없어요.\n설정에서 날씨 알림을 받을 수 있어요.")

    private lazy var dataSource = NotificationDataSource(
        collectionView: self.collectionView
    )

    override init() {
        super.init()
        title = "알림"
        setLayouts()
        dataSource.update(list: [])
        collectionView.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

extension NotificationListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = false
            let section = NSCollectionLayoutSection.list(
                using: config,
                layoutEnvironment: layoutEnvironment
            )
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
    }
}

extension NotificationListViewController {
    private func setLayouts() {
        view.addSubviews(emptyLabel, collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
}
