//
//  RegistrationClothesViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/23.
//

import UIKit

final class RegistrationClothesViewController: BaseViewController {
    private let registrationView = RegistrationClothesView()

    override func loadView() {
        view = registrationView
    }
}
