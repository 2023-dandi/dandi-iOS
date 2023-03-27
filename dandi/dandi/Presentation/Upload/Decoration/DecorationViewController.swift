//
//  DecorationViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/26.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import YDS

final class DecorationViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private var initialMenuViewCenter: CGPoint = .zero

    private var stickers: [StickerEditorView] = []
    private lazy var imageView = DecorationImageView()
    private let menuView = DecorationMenuView()
    private let doneButton = UIButton()

    override init() {
        super.init()
        setProperties()
        setLayouts()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initialMenuViewCenter = menuView.center
    }

    private func setLayouts() {
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
        view.addSubviews(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(UIScreen.main.bounds.width * 433 / 375)
        }
        imageView.image = Image.background1
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(UIScreen.main.bounds.width * 433 / 375)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 2 / 3).priority(.high)
        }
    }

    private func setProperties() {
        imageView.isUserInteractionEnabled = true
        let gesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handleGesture)
        )
        menuView.addGestureRecognizer(gesture)
        menuView.isUserInteractionEnabled = true
        doneButton.setImage(
            YDSIcon.checkLine
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(YDSColor.buttonNormal),
            for: .normal
        )
        navigationItem.setRightBarButton(
            UIBarButtonItem(customView: doneButton),
            animated: false
        )

        let closet = ModuleFactory.shared.makeClosetTabViewController()
        closet.addImageDeleagte = self
        closet.update(
            category: ["전체", "상의", "아우터", "악세사리", "기타패션"],
            tagList: ["봄", "겨울", "가을", "겨울"],
            photo: [.add, .checkmark, .strokedCheckmark, .remove]
        )

        let background = ModuleFactory.shared.makeBackgroundTabViewController()
        background.addImageDelegate = self

        let sticker = ModuleFactory.shared.makeStickerTabViewController()
        sticker.addImageDelegate = self

        setViewControllers([closet, background, sticker])
    }

    private func setViewControllers(_ viewControllers: [UIViewController]) {
        for (tag, viewController) in viewControllers.enumerated() {
            viewController.view.tag = tag
            viewController.view.isHidden = tag != 0
            menuView.buttons.append(PagerButton(viewController.title ?? ""))
            embed(
                parent: self,
                container: menuView,
                child: viewController, previous: nil
            )
        }
        menuView.views = viewControllers.compactMap { $0.view }
        for (tag, button) in menuView.buttons.enumerated() {
            button.tag = tag
            button.isSelected = tag == 0
            button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        }
        menuView.buttons.forEach { menuView.menuBar.addArrangedSubview($0) }
    }

    private func embed(
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
            make.top.equalTo(menuView.menuBar.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }

    private func bind() {
        doneButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.stickers.forEach {
                    $0.switchControls(toState: false)
                }
                guard let image = owner.imageView.makeImage() else { return }
                owner.stickers.forEach {
                    $0.switchControls(toState: true)
                }
                owner.navigationController?.pushViewController(
                    owner.factory.makeUploadMainViewController(image: image),
                    animated: true
                )
            })
            .disposed(by: disposeBag)
    }
}

extension DecorationViewController {
    
}

extension DecorationViewController {
    @objc
    private func buttonDidTap(_ button: UIButton) {
        menuView.buttons.forEach {
            $0.isSelected = $0.tag == button.tag
        }
        menuView.views.forEach {
            $0.isHidden = $0.tag != button.tag
        }
    }

    @objc func handleGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .ended, .cancelled:
            if sender.velocity(in: view).y < 0 {
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.0,
                    usingSpringWithDamping: 0.7,
                    initialSpringVelocity: 0.7,
                    options: [.curveLinear]
                ) {
                    self.menuView.center = CGPoint(
                        x: self.view.center.x,
                        y: self.view.center.y + 150
                    )
                }
                return
            }
            UIView.animate(
                withDuration: 0.5,
                delay: 0.0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.7,
                options: [.curveLinear]
            ) {
                self.menuView.center = self.initialMenuViewCenter
            }
        default:
            sender.setTranslation(CGPoint.zero, in: view)
        }
    }
}

extension DecorationViewController: StickerEditorViewDelegate {
    func delete(uuid: UUID) {
        stickers = stickers.filter { $0.uuid != uuid }
    }
}

extension DecorationViewController: AddImageDelegate {
    func add(_ viewController: UIViewController, image: UIImage) {
        switch viewController {
        case is ClosetTabViewController, is StickerTabViewController:
            let userResizableView = StickerEditorView(image: image)
            if userResizableView.touchStart == nil {
                userResizableView.center = CGPoint(
                    x: UIScreen.main.bounds.width / 2,
                    y: UIScreen.main.bounds.width * 1.1 / 2
                )
            }
            userResizableView.delegate = self
            stickers.append(userResizableView)
            imageView.addSubview(userResizableView)
        case is BackgroundTabViewController:
            imageView.image = image
        default:
            return
        }
    }
}
