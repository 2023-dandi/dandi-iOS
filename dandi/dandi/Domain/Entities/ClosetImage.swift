//
//  ClosetImage.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/19.
//

import Foundation
import UIKit

struct ClosetImage {
    let uuid = UUID()
    let id: Int?
    let image: UIImage?
    let imageURL: String?
}

extension ClosetImage: Equatable, Hashable {
    static func == (lhs: ClosetImage, rhs: ClosetImage) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
