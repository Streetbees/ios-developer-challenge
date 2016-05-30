//
//  ImageCache.swift
//  MarvelMeUp
//
//  Created by Dimitar Chakarov on 5/24/16.
//  Copyright © 2016 JI Apps Ltd. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {

    static let sharedCache: NSCache = {
        let cache = NSCache()
        cache.name = "ImageCache"
        cache.countLimit = 300 // Max 120 images in memory.
        cache.totalCostLimit = 120*200*200
        return cache
    }()

}

extension NSURL {

    var cachedImage: UIImage? {
        return ImageCache.sharedCache.objectForKey(absoluteString) as? UIImage
    }

    func fetchImage(completion: UIImage -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(self) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            if let
                data = data,
                image = UIImage(data: data) {
                ImageCache.sharedCache.setObject(image, forKey: self.absoluteString, cost: data.length)
                dispatch_async(dispatch_get_main_queue()) {
                    completion(image)
                }
            }
        }
        task.resume()
    }
    
}