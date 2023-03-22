//
//  PhotoLibraryViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/22.
//

import UIKit

import SnapKit
import Then
import YDS
import YPImagePicker

final class PhotoLibraryViewController: YPImagePicker {
    init() {
        var config = YPImagePickerConfiguration()

        config.library.mediaType = YPlibraryMediaType.photo
        config.screens = [.library, .photo]
        config.startOnScreen = .library
        config.showsPhotoFilters = false

        config.library.skipSelectionsGallery = true

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
        didFinishPicking { [unowned self] items, cancelled in
            guard
                !cancelled,
                let firstItem = items.first
            else {
                self.dismiss(animated: true, completion: nil)
                return
            }

            switch firstItem {
            case .photo:
                break
            default:
                break
            }
            self.pushViewController(UIViewController(), animated: true)
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
