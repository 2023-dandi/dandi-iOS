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
import YDS

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
    private var resultImage: UIImage?
    private let contentScrollView = DecorationView()
    private let doneButton = YDSBoxButton()

    override func loadView() {
        view = contentScrollView
    }

    init(selectedImages: [UIImage]) {
        super.init()
        setProperties()
        setLayouts()
        makeStickerEditorViews(images: selectedImages)
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

        setCollectionViewDataSource()
        bind()
    }

    private func makeStickerEditorViews(images: [UIImage]) {
        images.forEach { stickers.append(StickerEditorView(image: $0)) }
    }

    private func setCollectionViewDataSource() {
        contentScrollView.collectionView.dataSource = self
        contentScrollView.collectionView.register(cell: DecorationHeaderView.self)
        contentScrollView.collectionView.register(cell: DecorationMenuCollectionViewCell.self)
    }

    private func setProperties() {
        doneButton.text = "꾸미기 완료"
        doneButton.rounding = .r8
    }

    private func setLayouts() {
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32)
        }
    }

    private func bind() {
        contentScrollView.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                switch indexPath.section {
                case 1:
                    owner.headerViewBackgroundImage = owner.backgroundImages[indexPath.item]
                    owner.contentScrollView.collectionView.reloadData()
                case 2:
                    owner.stickers.append(StickerEditorView(image: self.stickerImages[indexPath.item]))
                    owner.contentScrollView.collectionView.reloadData()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        doneButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.stickers.forEach {
                    $0.switchControls(toState: false)
                }
                guard
                    let cell = owner.contentScrollView
                    .collectionView
                    .cellForItem(at: IndexPath(item: 0, section: 0))
                    as? DecorationHeaderView,
                    let image = cell.makeImage()
                else { return }
                owner.stickers.forEach {
                    $0.switchControls(toState: true)
                }
                owner.navigationController?.pushViewController(
                    owner.factory.makeUploadMainViewController(image: image),
                    animated: true
                )
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
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DecorationHeaderView.identifier,
                    for: indexPath
                ) as? DecorationHeaderView
            else { return UICollectionViewCell() }
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
                cell.rawImageView.addSubview(userResizableView)
            }
            cell.rawImageView.image = headerViewBackgroundImage
            return cell
        case 1:
            let cell: DecorationMenuCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.update(
                category: ["전체", "상의", "아우터", "악세사리", "기타패션"],
                tagList: ["전체", "티셔츠", "셔츠", "맨투맨"],
                photo: [.add, .checkmark, .strokedCheckmark, .remove]
            )
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension DecorationViewController: StickerEditorViewDelegate {
    func delete(uuid: UUID) {
        stickers = stickers.filter { $0.uuid != uuid }
        contentScrollView.collectionView.reloadData()
    }
}
