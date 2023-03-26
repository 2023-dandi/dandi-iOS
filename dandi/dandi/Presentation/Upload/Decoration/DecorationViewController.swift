//
//  DecorationViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/28.
//

import UIKit

import PanModal
import RxCocoa
import RxSwift
import SnapKit
import YDS

final class DecorationViewController: BaseViewController {
    private let contentView = DecorationMenuView()

    override func loadView() {
        view = contentView
    }

    init(factory: ModulFactoryInterface) {
        super.init()
        super.factory = factory
        setContentView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setContentView() {
        contentView.parentViewController = self
        let closet = factory.makeClosetTabViewController()
        //        closet.addImageDeleagte = self
        closet.update(
            category: ["전체", "상의", "아우터", "악세사리", "기타패션"],
            tagList: ["봄", "겨울", "가을", "겨울"],
            photo: [.add, .checkmark, .strokedCheckmark, .remove]
        )

        let background = factory.makeBackgroundTabViewController()
        let sticker = factory.makeStickerTabViewController()

        contentView.setViewControllers([closet, background, sticker])
    }
}

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
//            contentView.imageView.addSubview(userResizableView)
//        case is BackgroundTabViewController:
//            headerViewBackgroundImage = image
//            contentScrollView.imageView.image = headerViewBackgroundImage
//        default:
//            return
//        }
//    }
// }
