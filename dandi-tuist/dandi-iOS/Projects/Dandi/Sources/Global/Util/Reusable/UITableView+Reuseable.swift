//
//  UITableView+Reuseable.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/16.
//

import UIKit

extension UITableViewCell: ReusableView {}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier,
                                             for: indexPath) as? T
        else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }

    func register<T>(
        cell: T.Type,
        forCellReuseIdentifier reuseIdentifier: String = T.reuseIdentifier
    ) where T: UITableViewCell {
        register(cell, forCellReuseIdentifier: reuseIdentifier)
    }

    func restore() {
        backgroundView = nil
    }
}
