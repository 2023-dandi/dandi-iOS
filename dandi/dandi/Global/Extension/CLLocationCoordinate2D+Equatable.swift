//
//  CLLocationCoordinate2D+Equatable.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/24.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return String(format: "%.1f", lhs.latitude) == String(format: "%.1f", rhs.latitude)
            && String(format: "%.1f", lhs.longitude) == String(format: "%.1f", rhs.longitude)
    }
}
