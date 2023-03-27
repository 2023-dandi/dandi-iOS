//
//  ClosetMainViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/27.
//

import UIKit

import RxCocoa
import RxSwift
import YDS

final class ClosetMainViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    enum ViewType {
        case `default`
        case isEditing

        var text: String {
            switch self {
            case .default: return "편집"
            case .isEditing: return "취소"
            }
        }

        var cellType: ImageCollectionViewCell.CellType {
            switch self {
            case .default: return .none
            case .isEditing: return .check
            }
        }
    }

    private let closetView = ClosetView()
    private let rightTopButton = UIButton()
    private var viewType: ViewType = .default {
        didSet {
            deleteButton.isHidden = viewType == .default
            rightTopButton.setTitle(viewType.text, for: .normal)
            closetView.photoCollectionView.reloadData()
        }
    }

    private let deleteButton = YDSBoxButton()

    private var category: [String] = []
    private var tagList: [String] = []
    private var photo: [UIImage] = []

    override func loadView() {
        view = closetView
    }

    override init() {
        super.init()
        setProperties()
        setLayouts()
        setCollectionView()
        bind()
    }

    func update(
        category: [String],
        tagList: [String],
        photo: [UIImage]
    ) {
        self.category = category
        self.tagList = tagList
        self.photo = photo
        reloadData()
    }

    private func setProperties() {
        title = "옷장"
        rightTopButton.setTitleColor(YDSColor.buttonNormal, for: .normal)
        rightTopButton.titleLabel?.font = YDSFont.button0
        navigationItem.setRightBarButton(UIBarButtonItem(customView: rightTopButton), animated: false)

        deleteButton.text = "삭제"
        deleteButton.size = .large
        deleteButton.rounding = .r8
        deleteButton.type = .filled

        viewType = .default
    }

    func bind() {
        rightTopButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                let isDefault = owner.viewType == .default
                owner.viewType = isDefault ? .isEditing : .default
            })
            .disposed(by: disposeBag)
    }

    private func reloadData() {
        closetView.categoryCollectionView.reloadData()
        closetView.tagCollectionView.reloadData()
        closetView.photoCollectionView.reloadData()
    }

    private func setCollectionView() {
        [closetView.categoryCollectionView,
         closetView.tagCollectionView,
         closetView.photoCollectionView].forEach {
            $0.delegate = self
            $0.dataSource = self
        }
    }

    private func setLayouts() {
        rightTopButton.snp.makeConstraints { make in
            make.size.equalTo(44).priority(.high)
        }
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(23)
        }
    }
}

extension ClosetMainViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection _: Int
    ) -> Int {
        switch collectionView {
        case closetView.categoryCollectionView:
            return category.count
        case closetView.tagCollectionView:
            return tagList.count
        case closetView.photoCollectionView:
            return photo.count
        default:
            return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch collectionView {
        case closetView.categoryCollectionView:
            let cell: CategoryTextCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(text: category[indexPath.item])
            return cell

        case closetView.tagCollectionView:
            let cell: RoundTagCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(text: tagList[indexPath.item])
            return cell

        case closetView.photoCollectionView:
            let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(image: photo[indexPath.item])
            dump(viewType.cellType)
            cell.type = viewType.cellType
            return cell

        default:
            return UICollectionViewCell()
        }
    }
}

extension ClosetMainViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        switch collectionView {
        case closetView.categoryCollectionView:
            print("mainCategoryTabCollectionView")
            print(indexPath)
        case closetView.tagCollectionView:
            print("tagTabCollectionView")
            print(indexPath)
        case closetView.photoCollectionView:
            print("photoCollectionView")
            print(indexPath)
        default:
            break
        }
    }
}
