//
//  Comic.swift
//  StreetBees-iOS-Marvel
//
//  Created by Javid Sheikh on 22/05/2016.
//  Copyright © 2016 Javid Sheikh. All rights reserved.
//

import UIKit

class Comic: NSObject {
    
    var comicTitle: String
    var comicCoverImageURLString: String
    
    init(comicTitle: String, comicCoverImageURLString: String) {
        self.comicTitle = comicTitle
        self.comicCoverImageURLString = comicCoverImageURLString
    }
    
}
