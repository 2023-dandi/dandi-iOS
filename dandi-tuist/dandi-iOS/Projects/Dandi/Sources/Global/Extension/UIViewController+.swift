//
//  UIViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/02/27.
//

import UIKit

extension UIViewController {
    func setStatusBarColor(isLight: Bool) {
        navigationController?.navigationBar.barStyle = isLight ? .default : .black
    }

    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
