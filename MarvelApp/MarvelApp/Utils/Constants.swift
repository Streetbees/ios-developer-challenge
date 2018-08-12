//
//  Constants.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation

struct k {
    
    struct API {
        
        //Defining all the API request url constants
        static let BASE_URL = "https://gateway.marvel.com:443/"
        static let VERSION = "v1/"
        static let ACCESS = "public/"
        static let END_POINT = "comics"
        
        struct PARAMETERS {
            //Type of data we're expecting to get back from the API
            static let FORMAT = "comic"
            static let FORMAT_TYPE = "comic"
            //Number of items we're expecting to get back
            static let LIMIT = "100"
            //Defining API authorisation keys
            static let PUBLIC_KEY = "f8e53cab5ee84fa7b29e5b722101c193"
            static let PRIVATE_KEY = "54e56a70f70a42e5490b4732609d6abe188d975d"
        }
        
    }
    
}
