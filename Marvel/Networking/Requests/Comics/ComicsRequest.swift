//
//  ComicsRequest.swift
//  Marvel
//
//  Created by Gabriel Massana on 18/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

import CoreNetworking

class ComicsRequest: Request {

    //MARK: - Init
    
    /**
     Instanciate a new request with a given offset.
     */
    class func comicRequest()  -> Self {
        
        let comicsRequest = self.requestForAPI()
        
        return comicsRequest
    }
    
    //MARK: - UpdateRequest
    
    override func updateRequestWithEndpoint(endpoint: String, offset: String) {
        
        let UUID: String = NSUUID().UUIDString
        let hashString: String = NSString(format: "%@%@%@", UUID, PrivateKey, PublicKey) as String
        let md5: String = hashString.md5()
        
        let url: String = String(format:"https://gateway.marvel.com%@?offset=%@&ts=%@&apikey=%@&hash=%@&orderBy=-onsaleDate", endpoint, offset, UUID, PublicKey, md5)
        
        HTTPMethod = CNMHTTPRequestMethodGet
        URL = NSURL(string: url)
    }
}
