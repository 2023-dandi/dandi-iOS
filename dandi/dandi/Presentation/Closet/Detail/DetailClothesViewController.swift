//
//  DetailClothesViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/03.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import YDS

final class DetailClothesViewController: BaseViewController, View {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    typealias Reactor = DetailClothesReactor

    private let moreButton: UIButton = .init()
    private let imageView: UIImageView = .init()
    private let infoTitleLabel: UILabel = .init()
    private let categoryTitleLabel: UILabel = .init()
    private let categoryLabel: UILabel = .init()
    private let seasonsTitleLabel: UILabel = .init()
    private let seasonsLabel: UILabel = .init()

    override init() {
        super.init()
        setProperties()
        setLayouts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    func bind(reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.fetch }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        let moreButtonDidTap = moreButton.rx.tap
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Observable<ClothesDetailAlertType> in
                let actions: [ClothesDetailAlertType] = [.delete]
                return owner.rx.makeActionSheet(
                    title: "해당 옷을 어떻게 할까요?",
                    actions: actions,
                    closeAction: Alert(title: "닫기", style: .cancel)
                )
            }

        moreButtonDidTap.filter { $0 == .delete }
            .map { _ in Reactor.Action.delete }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.clothes }
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { owner, clothes in
                owner.imageView.image(url: clothes.imageURL)
                owner.categoryLabel.text = clothes.category.text
                owner.seasonsLabel.text = clothes.seasons.map { $0.text }.joined(separator: ",")
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.isDeleted }
            .withUnretained(self)
            .subscribe(onNext: { owner, isDeleted in
                if isDeleted {
                    NotificationCenterManager.reloadCloset.post()
                    owner.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }

    private func setProperties() {
        title = "내 옷"
        moreButton.setImage(YDSIcon.dotsVerticalLine.withRenderingMode(.alwaysTemplate), for: .normal)
        moreButton.tintColor = YDSColor.buttonNormal
        navigationItem.setRightBarButton(UIBarButtonItem(customView: moreButton), animated: false)

        infoTitleLabel.font = YDSFont.title3
        [categoryTitleLabel, seasonsTitleLabel].forEach {
            $0.font = YDSFont.subtitle2
            $0.textColor = YDSColor.textPrimary
        }
        [categoryLabel, seasonsLabel].forEach {
            $0.font = YDSFont.body2
            $0.textColor = YDSColor.textSecondary
            $0.textAlignment = .right
            $0.text = "  "
        }
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = YDSColor.bgSelected

        infoTitleLabel.text = "옷 정보"
        categoryTitleLabel.text = "카테고리"
        seasonsTitleLabel.text = "계절감"
    }

    private func setLayouts() {
        view.addSubviews(
            imageView,
            infoTitleLabel,
            categoryTitleLabel,
            categoryLabel,
            seasonsTitleLabel,
            seasonsLabel
        )

        imageView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(imageView.snp.width)
        }
        infoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(24)
        }
        categoryTitleLabel.snp.makeConstraints {
            $0.top.equalTo(infoTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(24)
        }
        seasonsTitleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(24)
        }
        categoryLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalTo(categoryTitleLabel.snp.centerY)
            $0.leading.equalToSuperview().inset(90)
        }
        seasonsLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalTo(seasonsTitleLabel.snp.centerY)
            $0.leading.equalToSuperview().inset(90)
        }
    }
}
