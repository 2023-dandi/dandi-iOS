//
//  UploadMainViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/14.
//

import UIKit

import SnapKit
import YDS

final class UploadMainViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private let uploadView = UploadMainView()
    private let uploadButton = YDSBoxButton()
    private let gradientBackgroundView = UIView()
    private let image: UIImage

    override func loadView() {
        view = uploadView
    }

    init(image: UIImage) {
        self.image = image
        super.init()
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientBackgroundView.addGradient(colors: [UIColor.white.withAlphaComponent(0), .white])
    }

    private func setPropeties() {
        uploadButton.text = "업로드"
        uploadButton.rounding = .r8

        uploadView.collectionView.dataSource = self
        uploadView.collectionView.register(cell: ClosetImageCollectionViewCell.self)
        uploadView.collectionView.register(cell: TagCollectionViewCell.self)
        uploadView.collectionView.register(cell: UploadWeatherCollectionViewCell.self)
        uploadView.collectionView.register(
            SectionTitleHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionTitleHeaderView.reuseIdentifier
        )
    }

    private func setLayouts() {
        view.addSubviews(gradientBackgroundView, uploadButton)
        gradientBackgroundView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.top.equalTo(uploadButton.snp.bottom)
        }
        uploadButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
    }
}

extension UploadMainViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 4
    }

    func collectionView(
        _: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0, 1:
            return 1
        case 2:
            return ClothesFeeling.allCases.count
        case 3:
            return WeatherFeeling.allCases.count
        default:
            return 0
        }
    }

    func collectionView(
        _: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell: ClosetImageCollectionViewCell = uploadView.collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(image: image)
            return cell

        case 1:
            let cell: UploadWeatherCollectionViewCell = uploadView.collectionView.dequeueReusableCell(forIndexPath: indexPath)
            return cell

        case 2:
            let cell: TagCollectionViewCell = uploadView.collectionView.dequeueReusableCell(forIndexPath: indexPath)
            guard
                let text = ClothesFeeling(rawValue: indexPath.item)?.text
            else { return UICollectionViewCell() }
            cell.configure(text: text)
            return cell

        case 3:
            let cell: TagCollectionViewCell = uploadView.collectionView.dequeueReusableCell(forIndexPath: indexPath)
            guard
                let text = WeatherFeeling(rawValue: indexPath.item)?.text
            else { return UICollectionViewCell() }
            cell.configure(text: text)
            return cell

        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(
        _: UICollectionView,
        viewForSupplementaryElementOfKind _: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch indexPath.section {
        case 2:
            let header: SectionTitleHeaderView = uploadView
                .collectionView
                .dequeueHeaderView(forIndexPath: indexPath)
            header.configure(text: "이 옷은 어땠나요?")
            return header
        case 3:
            let header: SectionTitleHeaderView = uploadView
                .collectionView
                .dequeueHeaderView(forIndexPath: indexPath)
            header.configure(text: "추가로 얘기하자면,")
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
