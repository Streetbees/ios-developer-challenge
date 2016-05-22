//
//  Authentication.swift
//  MarvelBees
//
//  Created by Andy on 21/05/2016.
//  Copyright © 2016 Pyrotechnic Apps Ltd. All rights reserved.
//

import Foundation
import CryptoSwift


class Authentication {
    
    var timeStamp = NSDate().timeIntervalSince1970.description
    let publicKey = "9be75bf4626446510afb05ce61a87743"

    func generateHash() -> String {
        
        timeStamp = NSDate().timeIntervalSince1970.description
        log.debug("Timestamp: \(timeStamp)")
        let privateKey = ""
        let input = "\(timeStamp)\(privateKey)\(publicKey)"
        let hash = input.md5()
        
        return hash
    }
    
}
