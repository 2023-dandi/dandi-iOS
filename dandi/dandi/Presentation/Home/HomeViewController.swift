//
//  HomeViewController.swift
//  dandi
//
//  Created by 김윤서 on 2022/12/30.
//

import UIKit

import CoreLocation
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
    private let addButton: UIButton = .init()
    private let closetButton: UIButton = .init()
    private let writingButton: UIButton = .init()

    private let temperaturePublisher = PublishRelay<Temperatures>()
    private let likePublisher = PublishSubject<Int>()

    override func loadView() {
        view = homeView
    }

    override init() {
        super.init()
        setGradientColors()
        setLayouts()
        setProperties()
    }

    func bind(reactor: HomeReactor) {
        bindTapAction()
        bindState(reactor)
        bindAction(reactor)
    }

    private func bindState(_ reactor: Reactor) {
        let hourlyWeathers = reactor.state
            .compactMap { $0.hourlyWeathers }
            .distinctUntilChanged()

        let posts = reactor.state
            .compactMap { $0.posts }
            .distinctUntilChanged()

        let temperatures = reactor.state
            .compactMap { $0.temperature }
            .distinctUntilChanged()
            .share()

        Observable.combineLatest(hourlyWeathers, posts, temperatures) { hourlyWeathers, posts, temperatures in
            (hourlyWeathers, posts, temperatures)
        }
        .observe(on: MainScheduler.asyncInstance)
        .subscribe(onNext: { [weak self] hourlyWeathers, posts, temperatures in
            guard let self = self else { return }
            self.homeView.bannerView.locationLabel.text = UserDefaultHandler.shared.address
            guard let hourlyWeather = hourlyWeathers.first else { return }
            self.homeDataSource.update(
                recommedationText: hourlyWeather.temperature + "도 에는 민소매를 입었어요.",
                temperature: hourlyWeather.temperature,
                recommendation: [],
                timeWeathers: hourlyWeathers,
                posts: posts
            )
            self.homeView.configure(
                temperature: hourlyWeather.temperature,
                description: "최고\(temperatures.max)/최저\(temperatures.min)"
            )
        })
        .disposed(by: disposeBag)

        reactor.state
            .map { $0.updateLocationSuccess }
            .distinctUntilChanged()
            .subscribe(onNext: { success in
                dump(success)
            })
            .disposed(by: disposeBag)

        temperatures
            .withUnretained(self)
            .subscribe(onNext: { owner, temperature in
                owner.temperaturePublisher.accept(temperature)
            })
            .disposed(by: disposeBag)

        NotificationCenterManager.reloadPost.addObserver()
            .map { postID in
                guard let postID = postID as? Int else { return nil }
                return postID
            }
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe(onNext: { owner, likedPostID in
                guard let oldPostItem = owner.homeDataSource.getPostItem(id: likedPostID) else { return }
                let newPostItem = Post(
                    id: oldPostItem.id,
                    mainImageURL: oldPostItem.mainImageURL,
                    profileImageURL: oldPostItem.profileImageURL,
                    nickname: oldPostItem.nickname,
                    date: oldPostItem.date,
                    content: oldPostItem.content,
                    tag: oldPostItem.tag,
                    isLiked: !oldPostItem.isLiked,
                    isMine: oldPostItem.isMine
                )
                owner.homeDataSource.reloadIfNeeded(item: newPostItem)
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.likedPostID }
            .distinctUntilChanged()
            .subscribe()
            .disposed(by: disposeBag)
    }

    private func bindAction(_ reactor: Reactor) {
        let shouldReload = Observable.merge([
            rx.viewWillAppear.take(1).map { _ in },
            NotificationCenterManager.reloadLocation.addObserver().map { _ in }
        ]).share()

        shouldReload
            .map { _ in Reactor.Action.fetchWeatherInfo }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        shouldReload
            .map { _ in Reactor.Action.fetchTemperatures }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        temperaturePublisher
            .map { Reactor.Action.fetchPostList(min: $0.min, max: $0.max) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        likePublisher
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { Reactor.Action.like(id: $0) }
            .bind(to: reactor.action)
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
                case let .post(id):
                    owner.navigationController?.pushViewController(
                        owner.factory.makePostDetailViewController(postID: id),
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

extension HomeViewController: RotaionDelegate {
    func rotate() {
        addButton.transform = CGAffineTransform(rotationAngle: 0)
    }
}

extension HomeViewController: HeartButtonDelegate {
    func buttonDidTap(postID: Int) {
        likePublisher.onNext(postID)
        NotificationCenterManager.reloadPost.post(object: postID)
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
