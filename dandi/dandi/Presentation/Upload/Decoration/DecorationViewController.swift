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
    private let rawImageView = UIView()

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
        view.addSubview(rawImageView)
        rawImageView.backgroundColor = .brown
//        stickers.append(StickerEditorView(image: Image.defaultProfile))
        let userResizableView = StickerEditorView(image: Image.defaultProfile)
        userResizableView.center = view.center
        rawImageView.addSubview(userResizableView)
        rawImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
