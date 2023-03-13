//
//  DecorationViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/28.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class DecorationViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private var stickers = [StickerEditorView]()
    private let backgroundImages = [
        Image.background1,
        Image.background2,
        Image.background3,
        Image.background4,
        Image.background5,
        Image.background6,
        Image.background7
    ]
    private let stickerImages = [
        Image.sticker1,
        Image.sticker2,
        Image.sticker3,
        Image.sticker4,
        Image.sticker5,
        Image.sticker6,
        Image.sticker7
    ]
    private var headerViewBackgroundImage: UIImage = Image.background1
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

        stickers.append(StickerEditorView(image: Image.defaultProfile))
        stickers.append(StickerEditorView(image: Image.defaultProfile))
        stickers.append(StickerEditorView(image: Image.defaultProfile))
        stickers.append(StickerEditorView(image: Image.defaultProfile))

        setCollectionViewDataSource()
        bind()
    }

    private func setCollectionViewDataSource() {
        contentScrollView.collectionView.dataSource = self
        contentScrollView.collectionView.register(
            StickerCollectionViewCell.self,
            forCellWithReuseIdentifier: StickerCollectionViewCell.identifier
        )
        contentScrollView.collectionView.register(
            DecorationHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DecorationHeaderView.identifier
        )
    }

    private func bind() {
        contentScrollView.collectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                switch indexPath.section {
                case 0:
                    self.headerViewBackgroundImage = self.backgroundImages[indexPath.item]
                    self.contentScrollView.collectionView.reloadData()
                default:
                    self.stickers.append(StickerEditorView(image: self.stickerImages[indexPath.item]))
                    self.contentScrollView.collectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension DecorationViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 2
    }

    func collectionView(
        _: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if section == 0 {
            return backgroundImages.count
        }
        return stickerImages.count
    }

    func collectionView(
        _: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = contentScrollView.collectionView.dequeueReusableCell(
                withReuseIdentifier: StickerCollectionViewCell.identifier,
                for: indexPath
            ) as? StickerCollectionViewCell
        else { return UICollectionViewCell() }

        switch indexPath.section {
        case 0:
            cell.configure(image: backgroundImages[indexPath.item])
        case 1:
            cell.configure(image: stickerImages[indexPath.item])
        default:
            break
        }

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
            if userResizableView.touchStart == nil {
                userResizableView.center = CGPoint(
                    x: UIScreen.main.bounds.width / 2,
                    y: UIScreen.main.bounds.width * 1.1 / 2
                )
            }
            userResizableView.tag = indexPath.item
            userResizableView.delegate = self
            header.rawImageView.addSubview(userResizableView)
        }
        header.rawImageView.image = headerViewBackgroundImage

        return header
    }
}

extension DecorationViewController: StickerEditorViewDelegate {
    func delete(uuid: UUID) {
        stickers = stickers.filter { $0.uuid != uuid }
        contentScrollView.collectionView.reloadData()
    }
}
