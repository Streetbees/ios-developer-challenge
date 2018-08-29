//
//  UIImageView+Additions.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 29/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func download(image url: String) {
        guard let imageURL = URL(string:url) else {
            return
        }
        self.kf.indicatorType = .activity
        self.kf.setImage(with: ImageResource(downloadURL: imageURL), options: [.transition(.fade(0.2))])
    }
}
