//
//  LocationConverter.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/07.
//

import CoreLocation
import Foundation

struct MapGridData {
    let re = 6371.00877 // 사용할 지구반경  [ km ]
    let grid = 5.0 // 사용할 지구반경  [ km ]
    let slat1 = 30.0 // 표준위도       [degree]
    let slat2 = 60.0 // 표준위도       [degree]
    let olon = 126.0 // 기준점의 경도   [degree]
    let olat = 38.0 // 기준점의 위도   [degree]
    let xo = 42.0 // 기준점의 X좌표  [격자거리] // 210.0 / grid
    let yo = 135.0 // 기준점의 Y좌표  [격자거리] // 675.0 / grid
}

final class LocationConverter {
    private let map: MapGridData = .init()

    private let PI: Double = .pi
    private let DEGRAD: Double = .pi / 180.0
    private let RADDEG: Double = 180.0 / .pi

    private let re: Double
    private let slat1: Double
    private let slat2: Double
    private let olon: Double
    private let olat: Double
    private var sn: Double
    private var sf: Double
    private var ro: Double

    init() {
        self.re = map.re / map.grid
        self.slat1 = map.slat1 * DEGRAD
        self.slat2 = map.slat2 * DEGRAD
        self.olon = map.olon * DEGRAD
        self.olat = map.olat * DEGRAD

        self.sn = tan(PI * 0.25 + slat2 * 0.5) / tan(PI * 0.25 + slat1 * 0.5)
        self.sn = log(cos(slat1) / cos(slat2)) / log(sn)
        self.sf = tan(PI * 0.25 + slat1 * 0.5)
        self.sf = pow(sf, sn) * cos(slat1) / sn
        self.ro = tan(PI * 0.25 + olat * 0.5)
        self.ro = re * sf / pow(ro, sn)
    }

    func convertGrid(lon: Double, lat: Double) -> (Int, Int) {
        var ra: Double = tan(PI * 0.25 + lat * DEGRAD * 0.5)
        ra = re * sf / pow(ra, sn)
        var theta: Double = lon * DEGRAD - olon

        if theta > PI {
            theta -= 2.0 * PI
        }

        if theta < -PI {
            theta += 2.0 * PI
        }

        theta *= sn

        let x: Double = ra * sin(theta) + map.xo
        let y: Double = ro - ra * cos(theta) + map.yo

        return (Int(x + 1.5), Int(y + 1.5))
    }

    func fetchAddress(
        latitude: Double,
        longitude: Double,
        completion: @escaping (String) -> Void
    ) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)

        let local = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(location, preferredLocale: local) { placemarks, _ in
            guard let placemark = placemarks?.first else { return }
            var address = ""
            if let country = placemark.country {
                address = country
            }
            if let locality = placemark.locality {
                address += " "
                address += locality
            }
            if let thoroughfare = placemark.thoroughfare {
                address += " "
                address += thoroughfare
            }
            completion(address)
        }
    }
}
