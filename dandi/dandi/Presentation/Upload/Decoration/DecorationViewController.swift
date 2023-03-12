//
//  DecorationViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/28.
//

import UIKit

final class DecorationViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private let decorationView = DecorationView()
    private let imageView = ImageGestureView()
    private var deltaAngle: CGFloat = 0

    override func loadView() {
        view = decorationView
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

        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(200)
        }
        imageView.imageView.image = .remove
        imageView.isMultipleTouchEnabled = true

        let tapGesture = UIPanGestureRecognizer(target: self, action: #selector(dragImg(_:)))
        imageView.imageView.addGestureRecognizer(tapGesture)
        imageView.imageView.isUserInteractionEnabled = true

        let scaleImage = UIPanGestureRecognizer(target: self, action: #selector(scaleImg(_:)))
        imageView.zoomIcon.addGestureRecognizer(scaleImage)
        imageView.zoomIcon.isUserInteractionEnabled = true
    }
}

extension DecorationViewController {
    @objc
    func dragImg(_ sender: UIPanGestureRecognizer) {
        // 이동
        let translation = sender.translation(in: view)
        imageView.center = CGPoint(
            x: imageView.center.x + translation.x,
            y: imageView.center.y + translation.y
        )
        sender.setTranslation(CGPoint.zero, in: view)
    }

    @objc
    func scaleImg(_ sender: UIPanGestureRecognizer) {
        // 사이즈 조정
        let translation = sender.translation(in: view)
        if abs(translation.x) < 20 || abs(translation.y) < 20 {
            return
        }
        let ratio = min(abs(translation.y) / 100, 2)
        imageView.transform = CGAffineTransform(scaleX: max(ratio, 0.8), y: max(ratio, 0.8))
    }
}
