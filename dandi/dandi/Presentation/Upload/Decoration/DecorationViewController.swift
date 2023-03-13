//
//  DecorationViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/28.
//

import UIKit

import SnapKit

final class DecorationViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private var stickers = [StickerEditorView]()
    private var headerView: DecorationHeaderView?
    private let contentScrollView = DecorationView()

    override func loadView() {
        view = contentScrollView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        stickers.append(StickerEditorView(image: Image.defaultProfile.resize(newWidth: 200)))
        stickers.append(StickerEditorView(image: Image.defaultProfile.resize(newWidth: 200)))
        stickers.append(StickerEditorView(image: Image.defaultProfile.resize(newWidth: 200)))
        stickers.append(StickerEditorView(image: Image.defaultProfile.resize(newWidth: 200)))

        setCollectionViewDataSource()
    }

    private func setCollectionViewDataSource() {
        contentScrollView.collectionView.dataSource = self
        contentScrollView.collectionView.register(
            ClosetImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ClosetImageCollectionViewCell.identifier
        )
        contentScrollView.collectionView.register(
            DecorationHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DecorationHeaderView.identifier
        )
    }
}

extension DecorationViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 2
    }

    func collectionView(
        _: UICollectionView,
        numberOfItemsInSection _: Int
    ) -> Int {
        return 10
    }

    func collectionView(
        _: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = contentScrollView.collectionView.dequeueReusableCell(
                withReuseIdentifier: ClosetImageCollectionViewCell.identifier,
                for: indexPath
            ) as? ClosetImageCollectionViewCell
        else { return UICollectionViewCell() }

        cell.configure(imageURL: "")

        return cell
    }

    func collectionView(
        _: UICollectionView,
        viewForSupplementaryElementOfKind _: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard
            indexPath.section == 0,
            let header = contentScrollView.collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: DecorationHeaderView.identifier,
                for: indexPath
            ) as? DecorationHeaderView
        else { return UICollectionReusableView() }
        stickers.forEach { stickerView in
            let userResizableView = stickerView
            userResizableView.center = CGPoint(
                x: UIScreen.main.bounds.width / 2,
                y: UIScreen.main.bounds.width * 1.1 / 2
            )
            header.rawImageView.addSubview(userResizableView)
        }

        return header
    }
}
