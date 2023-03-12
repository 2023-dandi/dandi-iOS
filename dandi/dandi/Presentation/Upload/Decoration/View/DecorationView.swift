//
//  DecorationView.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/12.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import YDS

final class DecorationView: UIView {
    let disposeBag: DisposeBag

    init(disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(images: [UIImage]) {
        setImages(images: images)
    }

    private func setImages(images: [UIImage]) {
        images.forEach { image in
            let imageGestureView = ImageGestureView()
            imageGestureView.imageView.image = image

            addSubview(imageGestureView)
            imageGestureView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(200)
            }
            imageGestureView.imageView.image = .remove
            imageGestureView.isMultipleTouchEnabled = true

            imageGestureView.imageView.rx.gesture(.pan())
                .debug()
                .subscribe(onNext: { [weak self] sender in
                    guard
                        let sender = sender as? UIPanGestureRecognizer,
                        let self = self
                    else { return }
                    let translation = sender.translation(in: self)
                    imageGestureView.center = CGPoint(
                        x: imageGestureView.center.x + translation.x,
                        y: imageGestureView.center.y + translation.y
                    )
                    sender.setTranslation(CGPoint.zero, in: self)
                })
                .disposed(by: disposeBag)

            imageGestureView.zoomIcon.rx.gesture(.pan())
                .debug()
                .subscribe(onNext: { [weak self] sender in
                    guard
                        let sender = sender as? UIPanGestureRecognizer,
                        let self = self
                    else { return }
                    // 사이즈 조정
                    let translation = sender.translation(in: self)
                    if abs(translation.x) < 20 || abs(translation.y) < 20 {
                        return
                    }
                    let ratio = min(abs(translation.y) / 100, 2)
                    imageGestureView.transform = CGAffineTransform(scaleX: max(ratio, 0.8), y: max(ratio, 0.8))

                })
                .disposed(by: disposeBag)

            imageGestureView.rx.tapGesture
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.bringSubviewToFront(imageGestureView)
                })
                .disposed(by: disposeBag)
        }
    }
}
