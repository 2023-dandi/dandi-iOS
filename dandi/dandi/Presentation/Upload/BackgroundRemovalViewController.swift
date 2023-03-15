//
//  SampleViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/14.
//

import BackgroundRemoval
import UIKit

final class SampleViewController: UIViewController {
    private let segmentedImage: UIImageView = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedImage.contentMode = .scaleAspectFit
        view.addSubview(segmentedImage)
        segmentedImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        let image = UIImage(named: "dog")
        segmentedImage.image = BackgroundRemoval().removeBackground(image: image!, maskOnly: false)
    }
}
