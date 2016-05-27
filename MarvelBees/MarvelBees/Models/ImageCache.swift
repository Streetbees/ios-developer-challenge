//
//  ImageCache.swift
//  MarvelBees
//
//  Created by Andy on 26/05/2016.
//  Copyright © 2016 Pyrotechnic Apps Ltd. All rights reserved.
//

import Foundation

/*struct ImageCache {
    let name: String
    let photoURLString: String
}


import UIKit

class ImageCache {
    
    static let sharedManager = PhotosDataManager()
    private var photos = [GlacierScenic]()
    
    //MARK: - Read Data
    
    func allPhotos() -> [GlacierScenic] {
        if !photos.isEmpty { return photos }
        guard let data = NSArray(contentsOfFile: dataPath()) as? [NSDictionary] else { return photos }
        for photoInfo in data {
            let name = photoInfo["name"] as! String
            let urlString = photoInfo["imageURL"] as! String
            let glacierScenic = GlacierScenic(name: name, photoURLString: urlString)
            photos.append(glacierScenic)
        }
        return photos
    }
    
    func dataPath() -> String {
        return NSBundle.mainBundle().pathForResource("GlacierScenics", ofType: "plist")!
    }
} */
    
