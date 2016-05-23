//
//  Constants.swift
//  StreetBees-iOS-Marvel
//
//  Created by Javid Sheikh on 22/05/2016.
//  Copyright © 2016 Javid Sheikh. All rights reserved.
//

import UIKit

struct Constants {
    
    struct Dropbox {
        static let APIKey = "3bbya96946327hg"
    }
    
    struct Marvel {
        static let publicKey = "6f7521b316143dba895259c9f1792a40"
        static let privateKey = "908461b50d271549034621114787fd036ef38396"
        static let baseURL = "https://gateway.marvel.com:443/v1/public/comics"
    }
    
    struct MarvelParameterKeys {
        static let format = "format"
        static let noVariants = "noVariants"
        static let dateRange = "dateRange"
        static let orderBy = "orderBy"
        static let limit = "limit"
        static let offset = "offset"
        static let APIKey = "apikey"
        static let timestamp = "ts"
        static let hash = "hash"
    }
    
    struct MarvelParameterValues {
        static let format = "comic"
        static let noVariants = "true"
        static let startDate = "1939-01-01%2C"
        static let orderBy = "-onsaleDate"
        static let limit = "50"
    }
    
}
