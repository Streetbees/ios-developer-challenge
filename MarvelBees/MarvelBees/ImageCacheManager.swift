//
//  ImageCacheManager.swift
//  MarvelBees
//
//  Created by Andy on 27/05/2016.
//  Copyright © 2016 Pyrotechnic Apps Ltd. All rights reserved.
//

class ImageCacheManager: NSObject {
    static let sharedInstance = ImageCacheManager()
    
    static let cacheKey = "dropboxImagesKey"
//    let imageCache = AutoPurgingImageCache(
//        memoryCapacity: 100 * 1024 * 1024,
//        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
//    )
}
