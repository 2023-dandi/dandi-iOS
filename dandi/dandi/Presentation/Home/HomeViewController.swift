//
//  HomeViewController.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import CoreLocation
import UIKit

import RxCocoa
import RxSwift
import YDS

final class HomeViewController: BaseViewController {
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
        bindTapAction()
        homeDataSource.update(
            dayWeathers: [
                DayWeatherInfo(
                    mainImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    date: "9월 11일",
                    detail: """
                        (동작구 상도동)은
                        오늘 (13도)에요.
                        한낮에는 더워도
                        밤에는 쌀쌀할 수 있어요!
                    """
                ),
                DayWeatherInfo(
                    mainImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    date: "9월 11일",
                    detail: """
                        (동작구 상도동)은
                        오늘 (13도)에요.
                        한낮에는 더워도
                        밤에는 쌀쌀할 수 있어요!
                    """
                ),
                DayWeatherInfo(
                    mainImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    date: "9월 11일",
                    detail: """
                        (동작구 상도동)은
                        오늘 (13도)에요.
                        한낮에는 더워도
                        밤에는 쌀쌀할 수 있어요!
                    """
                )

            ],
            timeWeathers: [
                TimeWeatherInfo(
                    image: .add,
                    time: "17시",
                    temperature: "17도"
                ),
                TimeWeatherInfo(
                    image: .add,
                    time: "17시",
                    temperature: "17도"
                ),
                TimeWeatherInfo(
                    image: .add,
                    time: "17시",
                    temperature: "17도"
                ),
                TimeWeatherInfo(
                    image: .add,
                    time: "17시",
                    temperature: "17도"
                ),
                TimeWeatherInfo(
                    image: .add,
                    time: "17시",
                    temperature: "17도"
                ),
                TimeWeatherInfo(
                    image: .add,
                    time: "17시",
                    temperature: "17도"
                ),
                TimeWeatherInfo(
                    image: .add,
                    time: "17시",
                    temperature: "17도"
                ),
                TimeWeatherInfo(
                    image: .add,
                    time: "17시",
                    temperature: "17도"
                ),
                TimeWeatherInfo(
                    image: .add,
                    time: "17시",
                    temperature: "17도"
                ),
                TimeWeatherInfo(
                    image: .add,
                    time: "17시",
                    temperature: "17도"
                )
            ],
            same: [
                Post(
                    id: 1,
                    mainImageURL: "https://cdn.imweb.me/thumbnail/20211105/16246701edcd5.jpg",
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "비오는 토요일",
                    date: "22.11.09 11:00",
                    content: "26도에 딱 적당해요!",
                    isLiked: false
                ),
                Post(
                    id: 2,
                    mainImageURL: "https://cdn.imweb.me/thumbnail/20211105/16246701edcd5.jpg",
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "비오는 토요일",
                    date: "22.11.09 11:00",
                    content: "26도에 딱 적당해요!",
                    isLiked: false
                ),
                Post(
                    id: 3,
                    mainImageURL: "https://cdn.imweb.me/thumbnail/20211105/16246701edcd5.jpg",
                    profileImageURL: "https://mblogthumb-phinf.pstatic.net/20140509_116/jabez5424_1399618275059rrU5H_JPEG/naver_com_20140509_153929.jpg?type=w2",
                    nickname: "비오는 토요일",
                    date: "22.11.09 11:00",
                    content: "26도에 딱 적당해요!",
                    isLiked: false
                )
            ]
        )
        homeView.configure(
            location: "상도동",
            temperature: "13",
            description: "추워요\n너무너무추워요"
        )
        homeView.setGradientColors(colors: [.red, .white])
        homeView.layoutSubviews()
        DefaultHomeWeatherUseCase(
            weatherRepository: DefaultWeatherRepository(
                weatherService: DefaultWeatherService()
            )).fetchWeatherInfo()
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

        let json = """
        {
          "response": {
            "header": {
              "resultCode": "00",
              "resultMsg": "NORMAL_SERVICE"
            },
            "body": {
              "dataType": "JSON",
              "items": {
                "item": [
                  {
                    "baseDate": "20230305",
                    "baseTime": "0500",
                    "category": "TMP",
                    "fcstDate": "20230305",
                    "fcstTime": "0600",
                    "fcstValue": "0",
                    "nx": 55,
                    "ny": 127
                  }
                ]
              },
              "pageNo": 1,
              "numOfRows": 1,
              "totalCount": 809
            }
          }
        }
        """.data(using: .utf8)!

        do {
            let weatherDTO = try JSONDecoder().decode(WeatherDTO.self, from: json)
            dump(weatherDTO)
        } catch {
            print(error)
        }
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
