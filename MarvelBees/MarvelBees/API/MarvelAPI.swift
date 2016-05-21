//
//  MarvelAPI.swift
//  MarvelBees
//
//  Created by Andy on 21/05/2016.
//  Copyright © 2016 Pyrotechnic Apps Ltd. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class MarvelAPI {
    
// MARK: - Properties
let marvelUrl = "http://gateway.marvel.com:80/v1/public/characters"

let timeStamp = NSDate().timeIntervalSince1970.description
var hash = String()

// MARK: - Public methods
func urlRequestWithRawBody(urlString:String, rawBody:String) -> (URLRequestConvertible) {
    
    // Create url request to send
    let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
    mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
    
    // Set content-type
    mutableURLRequest.setValue("", forHTTPHeaderField: "Content-Type")
    
    // Set the HTTPBody we'd like to submit
    let requestBodyData = NSMutableData()
    requestBodyData.appendData(rawBody.dataUsingEncoding(NSUTF8StringEncoding)!)
    
    mutableURLRequest.HTTPBody = requestBodyData
    
    // return URLRequestConvertible
    return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0)
}



// MARK: - Private methods






    
}
