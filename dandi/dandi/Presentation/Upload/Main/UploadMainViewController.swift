//
//  UploadMainViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/14.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import YDS

final class UploadMainViewController: BaseViewController, View {
    typealias Reactor = UploadMainReactor

    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private let uploadView = UploadMainView()
    private let uploadButton = YDSBoxButton()
    private let gradientBackgroundView = UIView()
    private let image: UIImage

    private var clothesFeeling: ClothesFeeling?
    private var weatherFeelings: [WeatherFeeling] = []
    private var temperature: TemperatureInfo? {
        didSet {
            DispatchQueue.main.async {
                self.uploadView.collectionView.reloadData()
            }
        }
    }

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

    func bind(reactor: Reactor) {
        bindCollectionView()
        bindAction(reactor)
        bindState(reactor)
    }

    private func bindAction(_ reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        uploadButton.rx.tap
            .debounce(.microseconds(500), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .map { owner, _ in
                Reactor.Action.upload(
                    image: owner.image,
                    clothesFeeling: owner.clothesFeeling,
                    weatherFeelings: owner.weatherFeelings
                )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindState(_ reactor: Reactor) {
        reactor.state
            .map { $0.temparature }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, temparature in
                owner.temperature = temparature
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, isLoading in
                owner.uploadButton.isDisabled = isLoading
            })
            .disposed(by: disposeBag)
    }

    // swiftlint:disable cyclomatic_complexity
    private func bindCollectionView() {
        uploadView.collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                switch indexPath.section {
                case 2:
                    guard
                        let item = ClothesFeeling(rawValue: indexPath.item),
                        let cell = self.uploadView.collectionView.cellForItem(at: indexPath)
                    else { return }
                    self.clothesFeeling = item
                    cell.isSelected = true
                    self.deselectAllItems(exclude: indexPath)
                case 3:
                    guard
                        let item = WeatherFeeling(rawValue: indexPath.item),
                        !self.weatherFeelings.contains(item)
                    else { return }
                    self.weatherFeelings.append(item)
                default:
                    return
                }
            })
            .disposed(by: disposeBag)

        uploadView.collectionView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                switch indexPath.section {
                case 2:
                    guard
                        let cell = self.uploadView.collectionView.cellForItem(at: indexPath),
                        let item = ClothesFeeling(rawValue: indexPath.item)
                    else { return }
                    if self.clothesFeeling == item {
                        self.clothesFeeling = nil
                    }
                    cell.isSelected = false
                case 3:
                    guard
                        let item = WeatherFeeling(rawValue: indexPath.item),
                        self.weatherFeelings.contains(item)
                    else { return }
                    self.weatherFeelings = self.weatherFeelings.filter { $0 != item }
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindTapAction() {
        uploadButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.pushViewController(owner.factory.makePostDetailViewController(postID: 11), animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func deselectAllItems(exclude: IndexPath, animated: Bool = false) {
        for indexPath in uploadView.collectionView.indexPathsForSelectedItems ?? [] {
            if indexPath == exclude { continue }
            if indexPath.section == 2 {
                uploadView.collectionView.deselectItem(at: indexPath, animated: animated)
                uploadView.collectionView.cellForItem(at: indexPath)?.isSelected = false
            }
        }
    }

    private func setPropeties() {
        uploadButton.text = "업로드"
        uploadButton.rounding = .r8

        uploadView.collectionView.do {
            $0.dataSource = self
            $0.register(cell: ClosetImageCollectionViewCell.self)
            $0.register(cell: TagCollectionViewCell.self)
            $0.register(cell: UploadWeatherCollectionViewCell.self)
            $0.register(
                SectionTitleHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: SectionTitleHeaderView.reuseIdentifier
            )
            $0.allowsMultipleSelection = true
        }
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
            if let temperature = temperature {
                cell.configure(
                    min: temperature.min,
                    max: temperature.max
                )
            }
            return cell

        case 2:
            let cell: TagCollectionViewCell = uploadView.collectionView.dequeueReusableCell(forIndexPath: indexPath)
            guard
                let item = ClothesFeeling(rawValue: indexPath.item)
            else { return UICollectionViewCell() }
            cell.configure(text: item.text)
            cell.isSelected = item == clothesFeeling
            return cell

        case 3:
            let cell: TagCollectionViewCell = uploadView.collectionView.dequeueReusableCell(forIndexPath: indexPath)
            guard
                let item = WeatherFeeling(rawValue: indexPath.item)
            else { return UICollectionViewCell() }
            cell.configure(text: item.text)
            cell.isSelected = weatherFeelings.contains(item)
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
