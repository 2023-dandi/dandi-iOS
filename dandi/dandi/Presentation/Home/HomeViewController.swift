//
//  HomeViewController.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import CoreLocation
import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import YDS

final class HomeViewController: BaseViewController, View {
    typealias Reactor = HomeReactor

    private let homeView: HomeView = .init()
    private lazy var homeDataSource: HomeDataSource = .init(
        collectionView: homeView.collectionView,
        presentingViewController: self
    )
    private let locationManager = CLLocationManager()

    override func loadView() {
        view = homeView
    }

    override init() {
        super.init()
        setLocationManager()
        setProperties()
    }

    func bind(reactor: HomeReactor) {
        bindTapAction()
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.hourlyWeathers }
            .withUnretained(self)
            .subscribe(onNext: { owner, hourlyWeathers in
                owner.homeDataSource.update(
                    timeWeathers: hourlyWeathers,
                    same: [Post(id: 0, mainImageURL: "", profileImageURL: "", nickname: "", date: "", content: "", isLiked: false)]
                )
            })
            .disposed(by: disposeBag)
    }

    private func setProperties() {
        homeView.setGradientColors(colors: [.red, .white])
        homeView.layoutSubviews()
    }

    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func bindTapAction() {
        homeView.addButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.pushViewController(
                    owner.factory.makeClosetViewController(),
                    animated: true
                )
            })
            .disposed(by: disposeBag)

        homeView.collectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                switch owner.homeDataSource.itemIdentifier(for: indexPath) {
                case let .post(post):
                    owner.navigationController?.pushViewController(
                        owner.factory.makePostDetailViewController(postID: post.id),
                        animated: true
                    )
                default: break
                }
            })
            .disposed(by: disposeBag)

        homeView.notificationButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.pushViewController(NotificationListViewController(), animated: true)
            }).disposed(by: disposeBag)
    }
}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(
        _: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            DandiLog.debug("GPS 권한 설정됨")
            locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            DandiLog.debug("GPS 권한 설정되지 않음")
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            DandiLog.debug("GPS 권한 요청 거부됨")
            showRequestLocationServiceAlert()
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            DandiLog.error("GPS 권한 Default")
        }
    }

    func locationManager(
        _: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }

        let geocoder = CLGeocoder()
        let local = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(location, preferredLocale: local) { [weak self] placemarks, _ in
            guard
                let self = self,
                let address: [CLPlacemark] = placemarks,
                let last = address.last
            else { return }
            self.homeView.bannerView.locationLabel.text = "\(last.locality ?? "") \(last.subLocality ?? "")"
        }
    }

    func locationManager(
        _: CLLocationManager,
        didFailWithError error: Error
    ) {
        DandiLog.error(error)
    }
}
