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
    
    func generateHash(timeStamp: String, privateKey: String, publicKey: String) -> String {
        
        let publicKey = ""
        let privateKey = ""
        
        let input = "\(timeStamp)\(privateKey)\(publicKey)"
        var hash: String { return input.md5() }
        
        return hash
    }

}
