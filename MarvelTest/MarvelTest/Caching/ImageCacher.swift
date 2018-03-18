//
//  ImageCacher.swift
//  MarvelTest
//
//  Created by Flávio Silvério on 18/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import Foundation
import UIKit

class ImageCacher {
    
    fileprivate var images : [String:UIImage] = [:]
    
    static let shared = ImageCacher()
    
    func add(_ image: UIImage, for urlString: String) {
        images[urlString] = image
    }
    
    func image(for urlString: String) -> UIImage? {
        
        guard let image = images[urlString] else { return nil }
        
        return image
    }
    
}
