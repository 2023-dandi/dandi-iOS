//
//  UIImage+Kingfisher.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/31.
//

import Kingfisher
import UIKit.UIImageView

extension UIImageView {
    func image(url: String?, defaultImage: UIImage? = UIImage()) {
        kf.indicatorType = .activity
        guard let urlString = url else {
            image = defaultImage
            return
        }
        if urlString.contains("/profile/default") {
            image = Image.defaultProfile
            return
        }
        let url = URL(string: urlString)
        kf.setImage(
            with: url,
            placeholder: .none,
            options: [
                .transition(ImageTransition.fade(0.5)),
                .backgroundDecode,
                .alsoPrefetchToMemory,
                .cacheMemoryOnly
            ]
        )
    }

    func cancelDownloadTask() {
        kf.cancelDownloadTask()
    }
}
