//
//  Hash.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation
import CryptoSwift


class Hash {
    
    var timestamp: String!
    var hashString: String!
    
    init(timestamp: String, hashString: String) {
        self.timestamp = timestamp
        self.hashString = hashString
    }
    
    class func getHash() -> Hash {
        
        let timestamp = generateTimestamp()!
        let hashString = generateHash(forTimeStamp: timestamp)!
        
        let hash = Hash(timestamp: timestamp, hashString: hashString)
        return hash
    }
    
    
    class func generateHash(forTimeStamp timestamp: String) -> String! {
        
        var hashString = ""
        
        hashString += timestamp
        hashString += k.API.PARAMETERS.PRIVATE_KEY
        hashString += k.API.PARAMETERS.PUBLIC_KEY
        
        return hashString.md5()
    }
    
    class func generateTimestamp() -> String! {
        
        return String(Date.timeIntervalSinceReferenceDate)
        
    }
    
}
