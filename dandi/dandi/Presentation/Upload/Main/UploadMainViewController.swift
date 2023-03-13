//
//  UploadMainViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/14.
//

import UIKit

import SnapKit

final class UploadMainViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private let imageView: UIImageView = .init()

    init(image: UIImage) {
        super.init()
        imageView.image = image

        setPropeties()
        setLayouts()
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

    private func setPropeties() {
        imageView.contentMode = .scaleAspectFit
    }

    private func setLayouts() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(imageView.snp.width).multipliedBy(1.2)
        }
    }
}
