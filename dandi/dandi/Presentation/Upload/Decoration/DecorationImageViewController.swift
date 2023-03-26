//
//  DecorationImageViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/26.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import YDS

final class DecorationImageViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private var stickers: [StickerEditorView] = []
    private lazy var imageView = DecorationImageView()
    private let contentView = DecorationMenuView()

    private let doneButton = UIButton()

    override init() {
        super.init()
        setProperties()
        setLayouts()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    private func setLayouts() {
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
        view.addSubviews(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(UIScreen.main.bounds.width * 433 / 375)
        }
        imageView.image = Image.background1
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
    }

    private func setProperties() {
        doneButton.setImage(
            YDSIcon.checkLine
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(YDSColor.buttonNormal),
            for: .normal
        )
        navigationItem.setRightBarButton(
            UIBarButtonItem(customView: doneButton),
            animated: false
        )
        contentView.parentViewController = self
        let closet = ModuleFactory.shared.makeClosetTabViewController()
        //        closet.addImageDeleagte = self
        closet.update(
            category: ["전체", "상의", "아우터", "악세사리", "기타패션"],
            tagList: ["봄", "겨울", "가을", "겨울"],
            photo: [.add, .checkmark, .strokedCheckmark, .remove]
        )

        let background = ModuleFactory.shared.makeBackgroundTabViewController()
        let sticker = ModuleFactory.shared.makeStickerTabViewController()

        contentView.setViewControllers([closet, background, sticker])
    }

    private func bind() {
        doneButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.stickers.forEach {
                    $0.switchControls(toState: false)
                }
                guard let image = owner.imageView.makeImage() else { return }
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

//
// extension DecorationViewController: UICollectionViewDataSource {
//    func collectionView(
//        _: UICollectionView,
//        numberOfItemsInSection _: Int
//    ) -> Int {
//        return 1
//    }
//
//    func collectionView(
//        _ collectionView: UICollectionView,
//        cellForItemAt indexPath: IndexPath
//    ) -> UICollectionViewCell {
//        let cell: DecorationMenuCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
//        cell.parentViewController = self
//
//        let closet = factory.makeClosetTabViewController()
//        closet.addImageDeleagte = self
//        closet.update(
//            category: ["전체", "상의", "아우터", "악세사리", "기타패션"],
//            tagList: ["봄", "겨울", "가을", "겨울"],
//            photo: [.add, .checkmark, .strokedCheckmark, .remove]
//        )
//
//        let background = factory.makeBackgroundTabViewController()
//        let sticker = factory.makeStickerTabViewController()
//
//        cell.setViewControllers([closet, background, sticker])
//        return cell
//    }
// }
//
// extension DecorationViewController: StickerEditorViewDelegate {
//    func delete(uuid: UUID) {
//        stickers = stickers.filter { $0.uuid != uuid }
//    }
// }
//
// extension DecorationViewController: AddImageDelegate {
//    func add(_ viewController: UIViewController, image: UIImage) {
//        switch viewController {
//        case is ClosetTabViewController:
//            let userResizableView = StickerEditorView(image: image)
//            if userResizableView.touchStart == nil {
//                userResizableView.center = CGPoint(
//                    x: UIScreen.main.bounds.width / 2,
//                    y: UIScreen.main.bounds.width * 1.1 / 2
//                )
//            }
//            userResizableView.delegate = self
//            contentScrollView.imageView.addSubview(userResizableView)
//        case is BackgroundTabViewController:
//            headerViewBackgroundImage = image
//            contentScrollView.imageView.image = headerViewBackgroundImage
//        default:
//            return
//        }
//    }
// }
