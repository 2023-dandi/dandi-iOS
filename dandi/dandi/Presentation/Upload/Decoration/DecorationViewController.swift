//
//  DecorationViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/28.
//

import UIKit

import RxGesture

final class DecorationViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private lazy var decorationView = DecorationView(disposeBag: self.disposeBag)
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
        decorationView.configure(images: [.add, .checkmark])
    }
}

//    private func setImages(images: [UIImage]) {
//        images.forEach { image in
//            let imageGestureView = ImageGestureView()
//            imageGestureView.imageView.image = image
//
//            view.addSubview(imageGestureView)
//            imageGestureView.snp.makeConstraints { make in
//                make.center.equalToSuperview()
//                make.size.equalTo(200)
//            }
//            imageGestureView.imageView.image = .remove
//            imageGestureView.isMultipleTouchEnabled = true
//
//            imageGestureView.imageView.rx.gesture(.pan())
//                .debug()
//                .subscribe(onNext: { [weak self] sender in
//                    guard
//                        let sender = sender as? UIPanGestureRecognizer,
//                        let self = self
//                    else { return }
//                    let translation = sender.translation(in: self.view)
//                    imageGestureView.center = CGPoint(
//                        x: imageGestureView.center.x + translation.x,
//                        y: imageGestureView.center.y + translation.y
//                    )
//                    sender.setTranslation(CGPoint.zero, in: self.view)
//                })
//                .disposed(by: disposeBag)
//
//            imageGestureView.zoomIcon.rx.gesture(.pan())
//                .debug()
//                .subscribe(onNext: { [weak self] sender in
//                    guard
//                        let sender = sender as? UIPanGestureRecognizer,
//                        let self = self
//                    else { return }
//                    // 사이즈 조정
//                    let translation = sender.translation(in: self.view)
//                    if abs(translation.x) < 20 || abs(translation.y) < 20 {
//                        return
//                    }
//                    let ratio = min(abs(translation.y) / 100, 2)
//                    imageGestureView.transform = CGAffineTransform(scaleX: max(ratio, 0.8), y: max(ratio, 0.8))
//
//                })
//                .disposed(by: disposeBag)
//        }
//    }
// }
