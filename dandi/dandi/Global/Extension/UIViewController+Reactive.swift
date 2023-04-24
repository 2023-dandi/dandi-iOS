//
//  UIViewController+Reactive.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/04.
//

import UIKit

import RxCocoa
import RxSwift

protocol AlertType {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}

class Alert: AlertType {
    let title: String
    let style: UIAlertAction.Style

    init(title: String, style: UIAlertAction.Style) {
        self.title = title
        self.style = style
    }
}

extension Reactive where Base: UIViewController {
    /// Alert
    func makeAlert<T: AlertType>(
        title: String?,
        message: String? = nil,
        actions: [T],
        closeAction: AlertType,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) -> Observable<T> {
        return Observable.create { [weak base] observer in
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            actions.forEach { action in
                let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(action)
                    observer.onCompleted()
                }
                alertController.addAction(alertAction)
            }

            let cancelAlertAction = UIAlertAction(title: closeAction.title, style: closeAction.style) { _ in
                observer.onCompleted()
            }
            alertController.addAction(cancelAlertAction)
            base?.present(alertController, animated: animated, completion: completion)
            return Disposables.create {
                alertController.dismiss(animated: animated)
            }
        }
    }

    /// Action Sheet
    func makeActionSheet<T: AlertType>(
        title: String?,
        message: String? = nil,
        actions: [T],
        closeAction: AlertType,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) -> Observable<T> {
        return Observable.create { [weak base] observer in
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .actionSheet
            )

            actions.forEach { action in
                let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(action)
                    observer.onCompleted()
                }
                alertController.addAction(alertAction)
            }

            let cancelAlertAction = UIAlertAction(title: closeAction.title, style: closeAction.style) { _ in
                observer.onCompleted()
            }
            alertController.addAction(cancelAlertAction)

            base?.present(alertController, animated: animated, completion: completion)

            return Disposables.create {
                alertController.dismiss(animated: animated)
            }
        }
    }
}
