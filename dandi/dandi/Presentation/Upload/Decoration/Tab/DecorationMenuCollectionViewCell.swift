//
//  DecorationMenuCollectionViewCell.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

import SnapKit
import Then
import YDS

final class DecorationMenuCollectionViewCell: UICollectionViewCell {
    private let menuBar = UIStackView()
    private var buttons: [PagerButton] = []
    private var views: [UIView] = []
    var parentViewController: UIViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setProperties()
        setLayouts()
    }

    func setViewControllers(_ viewControllers: [UIViewController]) {
        guard let parentViewController = parentViewController else { return }
        for (tag, viewController) in viewControllers.enumerated() {
            viewController.view.tag = tag
            viewController.view.isHidden = tag != 0
            buttons.append(PagerButton(viewController.title ?? ""))
            embed(
                parent: parentViewController,
                container: contentView,
                child: viewController, previous: nil
            )
        }
        views = viewControllers.compactMap { $0.view }
        for (tag, button) in buttons.enumerated() {
            button.tag = tag
            button.isSelected = tag == 0
            button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        }
        buttons.forEach { menuBar.addArrangedSubview($0) }
    }

    private func setProperties() {
        menuBar.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.borderColor = YDSColor.borderNormal
            $0.borderWidth = YDSConstant.Border.thin
        }
    }

    private func setLayouts() {
        contentView.addSubviews(menuBar)
        menuBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
    }

    @objc
    private func buttonDidTap(_ button: UIButton) {
        buttons.forEach {
            $0.isSelected = $0.tag == button.tag
        }
        views.forEach {
            $0.isHidden = $0.tag != button.tag
        }
    }

    func embed(
        parent: UIViewController,
        container: UIView,
        child: UIViewController,
        previous _: UIViewController?
    ) {
        child.willMove(toParent: parent)
        parent.addChild(child)
        container.addSubview(child.view)
        child.didMove(toParent: parent)
        child.view.snp.makeConstraints { make in
            make.top.equalTo(menuBar.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
