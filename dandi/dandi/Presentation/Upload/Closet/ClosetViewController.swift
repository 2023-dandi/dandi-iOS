//
//  ClosetViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/15.
//

import UIKit

import RxCocoa
import RxSwift
import YDS
import YPImagePicker

final class ClosetViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    override var isEditing: Bool {
        didSet {
            uploadButton.text = isEditing ? "삭제" : "업로드"
            rightTopButton.setTitle(isEditing ? "삭제" : "편집", for: .normal)
            title = isEditing ? "옷장 편집" : "옷장"
        }
    }

    private let closetView: ClosetView = .init()
    private let rightTopButton = YDSTopBarButton(text: "편집")
    private let uploadButton: YDSBoxButton = .init()

    private lazy var datasource: ClosetDataSource = .init(collectionView: closetView.collectionView)
    private var imageList = [UIImage]()

    override func loadView() {
        view = closetView
    }

    override init() {
        super.init()
        setProperties()
        setLayouts()
        datasource.update(
            imageURLs: [
                ClosetImage(id: 1, imageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2"),
                ClosetImage(id: 2, imageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2"),
                ClosetImage(id: 3, imageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2"),
                ClosetImage(id: 4, imageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2"),
                ClosetImage(id: 5, imageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2")
            ])
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    func bind() {
        closetView.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let item = owner.datasource.itemIdentifier(for: indexPath)
                switch item {
                case .button:
                    let library = owner.factory.makePhotoLibraryViewController()
                    library.modalPresentationStyle = .fullScreen
                    library.didFinishPicking { [unowned library] items, cancelled in
                        guard
                            !cancelled,
                            let firstItem = items.first
                        else {
                            library.dismiss(animated: true, completion: nil)
                            return
                        }

                        switch firstItem {
                        case .photo:
                            items.forEach { self.addImage($0) }
                        default:
                            break
                        }
                        library.dismiss(animated: true)
                    }
                    owner.present(library, animated: true)
                case let .image(image):
                    DandiLog.debug(image)
                case .none:
                    DandiLog.error("해당 Item 없음")
                }
            })
            .disposed(by: disposeBag)

        rightTopButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.isEditing.toggle()
            })
            .disposed(by: disposeBag)

        uploadButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if owner.isEditing {
                    // 삭제 API 호출
                    return
                }
                
            })
            .disposed(by: disposeBag)
    }

    private func setProperties() {
        title = "옷장"
        uploadButton.do {
            $0.size = .large
            $0.text = "업로드"
            $0.rounding = .r8
            $0.type = .filled
            $0.setBackgroundColor(YDSColor.buttonPointBG, for: .normal)
            $0.setBackgroundColor(YDSColor.buttonPointPressed, for: .highlighted)
        }
        navigationItem.setRightBarButton(UIBarButtonItem(customView: rightTopButton), animated: false)
    }

    private func setLayouts() {
        view.addSubview(uploadButton)
        uploadButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }

    private func addImage(_ item: YPMediaItem) {
        guard let image = convertItemToImage(with: item) else { return }
        imageList.append(image)
        // TODO: - 이미지 영상처리
    }

    private func convertItemToImage(with item: YPMediaItem) -> UIImage? {
        switch item {
        case let .photo(photo):
            return photo.image
        default:
            return nil
        }
    }
}
