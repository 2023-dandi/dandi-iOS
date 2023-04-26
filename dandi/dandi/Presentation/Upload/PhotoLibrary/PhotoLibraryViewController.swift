//
//  PhotoLibraryViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/22.
//

import UIKit

import BackgroundRemoval
import SnapKit
import Then
import YDS
import YPImagePicker

final class PhotoLibraryViewController: YPImagePicker {
    var factory: ModuleFactoryInterface!

    private var image: UIImage?

    init() {
        var config = YPImagePickerConfiguration()

        config.library.mediaType = YPlibraryMediaType.photo
        config.screens = [.library, .photo]
        config.startOnScreen = .library
        config.showsPhotoFilters = false

        config.library.skipSelectionsGallery = true
        config.library.onlySquare = true

        config.colors.albumTintColor = YDSColor.buttonPoint
        config.colors.tintColor = YDSColor.buttonPoint
        config.colors.trimmerHandleColor = YDSColor.buttonPoint
        config.colors.trimmerMainColor = YDSColor.buttonPoint
        config.colors.positionLineColor = YDSColor.buttonPoint

        config.wordings.libraryTitle = "모든 사진"
        config.wordings.cameraTitle = "카메라"
        config.wordings.next = "첨부"
        config.wordings.cancel = "취소"
        config.wordings.albumsTitle = "앨범"

        config.albumName = "단디"

        super.init(configuration: config)

        didFinishPickingCompletion()
    }

    private func didFinishPickingCompletion() {
        didFinishPicking { [weak self] items, cancelled in
            guard
                let self = self,
                !cancelled,
                let firstItem = items.first
            else {
                self?.dismiss(animated: true, completion: nil)
                return
            }

            switch firstItem {
            case .photo:
                items.forEach { self.addImage($0) }
            default:
                break
            }
            guard let image = self.image else { return }
            self.pushViewController(
                self.factory.makeRegisterClothesViewController(selectedImage: image),
                animated: true
            )
        }
    }

    private func addImage(_ item: YPMediaItem) {
        guard let image = convertItemToImage(with: item) else { return }
        let removeBackgroundImage = BackgroundRemoval().removeBackground(image: image, maskOnly: false)
        let imageView = UIImageView(image: removeBackgroundImage)

        // 레이어를 생성합니다.
        let layer = imageView.layer

        // 컨텍스트를 생성합니다.
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0.0)

        // 레이어를 그립니다.
        layer.render(in: UIGraphicsGetCurrentContext()!)

        // 이미지를 생성합니다.
        let image2 = UIGraphicsGetImageFromCurrentImageContext()

        // 컨텍스트를 종료합니다.
        UIGraphicsEndImageContext()

        guard let image2 = image2 else { return }
        self.image = image2
    }

    private func convertItemToImage(with item: YPMediaItem) -> UIImage? {
        switch item {
        case let .photo(photo):
            return photo.image
        default:
            return nil
        }
    }

    required init(configuration: YPImagePickerConfiguration) {
        super.init(configuration: configuration)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
