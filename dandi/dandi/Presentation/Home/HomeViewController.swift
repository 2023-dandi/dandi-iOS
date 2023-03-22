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
    private var coordinate = CLLocationCoordinate2D(
        /// 혜화역
        latitude: 37.58306203876132,
        longitude: 127.0020491941987
    ) {
        didSet {
            coordinatePublisher.accept(coordinate)
        }
    }

    private lazy var coordinatePublisher = BehaviorRelay<CLLocationCoordinate2D>(value: coordinate)
    private let addButton: UIButton = .init()
    private let closetButton: UIButton = .init()
    private let writingButton: UIButton = .init()

    override func loadView() {
        view = homeView
    }

    override init() {
        super.init()
        setLocationManager()
        setGradientColors()
        setLayouts()
        setProperties()
    }

    func bind(reactor: HomeReactor) {
        bindTapAction()

        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        coordinatePublisher
            .distinctUntilChanged()
            .map { Reactor.Action.updateLocation(lon: $0.longitude, lat: $0.latitude) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.hourlyWeathers }
            .withUnretained(self)
            .subscribe(onNext: { owner, hourlyWeathers in
                DispatchQueue.main.async {
                    guard let hourlyWeather = hourlyWeathers.first else { return }
                    owner.homeDataSource.update(
                        recommedationText: hourlyWeather.temperature + "도 에는 민소매를 입었어요.",
                        temperature: hourlyWeather.temperature,
                        recommendation: [ClosetImage(id: 1, image: nil, imageURL: nil), ClosetImage(id: 1, image: nil, imageURL: nil), ClosetImage(id: 1, image: nil, imageURL: nil)],
                        timeWeathers: hourlyWeathers,
                        same: [Post(id: 4, mainImageURL: "", profileImageURL: "", nickname: "", date: "", content: "", tag: [], isLiked: true, isMine: true)]
                    )
                    owner.homeView.configure(
                        temperature: hourlyWeather.temperature,
                        description: "한 낮에는 더워도\n 밤에는 쌀쌀할 수 있어요!"
                    )
                }
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.updateLocationSuccess }
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func setGradientColors() {
        switch Date().hour {
        case 6 ..< 8:
            homeView.setGradientColors(colors: [Color.pastelYellow, .white])
        case 8 ..< 18:
            homeView.setGradientColors(colors: [Color.pastelBlue, .white])
        case 18 ..< 19:
            homeView.setGradientColors(colors: [Color.pastelRed, .white])
        default:
            homeView.setGradientColors(colors: [Color.pastelPurple, .white])
        }
        homeView.layoutSubviews()
    }

    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func setProperties() {
        addButton.do {
            $0.cornerRadius = 30
            $0.backgroundColor = YDSColor.buttonPoint
            $0.setImage(
                YDSIcon.plusLine
                    .withRenderingMode(.alwaysOriginal)
                    .withTintColor(.white),
                for: .normal
            )
        }
    }

    private func setLayouts() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(60)
        }
    }

    private func bindTapAction() {
        addButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.addButton.transform = CGAffineTransform(rotationAngle: 180)
                let vc = owner.factory.makeHomeButtonViewController()
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.rotationDelegate = self
                vc.controllerDelegate = self
                owner.present(vc, animated: true, completion: nil)
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
        guard let location = locations.last else { return }
        coordinate = location.coordinate

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

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return String(format: "%.1f", lhs.latitude) == String(format: "%.1f", rhs.latitude)
            && String(format: "%.1f", lhs.longitude) == String(format: "%.1f", rhs.longitude)
    }
}

extension HomeViewController: RotaionDelegate {
    func rotate() {
        addButton.transform = CGAffineTransform(rotationAngle: 0)
    }
}

extension HomeViewController: ViewControllerDelegate {
    func presentViewController(_ viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated)
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
}
