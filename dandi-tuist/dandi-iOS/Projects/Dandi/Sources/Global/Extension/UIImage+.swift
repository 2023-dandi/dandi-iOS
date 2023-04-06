//
//  UIImage+.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/04.
//

import UIKit.UIImage

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }

    func withInset(_ insets: UIEdgeInsets) -> UIImage? {
        let cgSize = CGSize(
            width: size.width + insets.left * scale + insets.right * scale,
            height: size.height + insets.top * scale + insets.bottom * scale
        )

        UIGraphicsBeginImageContextWithOptions(cgSize, false, scale)
        defer { UIGraphicsEndImageContext() }

        let origin = CGPoint(x: insets.left * scale, y: insets.top * scale)
        draw(at: origin)

        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(renderingMode)
    }
}
