//
//  Request.swift
//  Marvel
//
//  Created by Gabriel Massana on 18/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

import CoreNetworking

let PublicKey: String = "6c3ee59b795443c3ec99cd142c50e639"
let PrivateKey: String = "3c5ec772a2885a3637466e4784d149a0c772b611"

class Request: CNMRequest {

    //MARK: - Init
    
    class func requestForAPI() -> Self  {
        
        
        let request = self.init()
        
        
        return request
    }
    
    //MARK: - UpdateRequest
    
    /**
    Updates the reqequest object with a given data.
    
    - parameter endpoint: specific endpoint for this request.
    - parameter offset: the offset of data to be ask for.
    */
    func updateRequestWithEndpoint(endpoint: String, offset: String) {
        
    }
}
