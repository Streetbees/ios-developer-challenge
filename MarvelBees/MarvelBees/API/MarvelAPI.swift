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

// TODO, shift these

class MarvelAPI {

    static let sharedInstance = MarvelAPI()
    
    // MARK: - Properties
    let publicKey = "9be75bf4626446510afb05ce61a87743"
    let privateKey = "1ccdaf259212de9f550d40348d291a79b1713c67"
    
    // MARK: - Private init (singleton)
    private init() {
    }
    
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
    func fetchComics(completion: ((success: Bool, Comics: [Comic]) -> ())) {
        
        let marvelComicsURL = "http://gateway.marvel.com:80/v1/public/comics"
        let authentication = Authentication()
        let hash = authentication.generateHash()
        log.debug("\(hash)")
        
        guard hash != "" else {
            log.error("Hash returned empty, please check keys")
            completion(success: false, Comics: [])
            return
        }
            
        // Add URL parameters
        let urlParameters = [
                "apikey":authentication.publicKey,
                "ts":authentication.timeStamp,
                "hash":hash,
                "orderBy":"onsaleDate"
                ]
            
            // Fetch Request
            Alamofire.request(.GET, marvelComicsURL, parameters: urlParameters)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    if (response.result.error == nil) {
                        log.verbose("HTTP Response Body: \(response.data)")
                    }
                    else {
                        log.verbose("HTTP Request failed: \(response.result.error)")
                    }
            }

        log.debug("marvelComicsURL is: \(marvelComicsURL)")
        Alamofire.request(.GET, marvelComicsURL, parameters: urlParameters)
            .validate(statusCode: 200..<300) // TODO: Check their status codes
            .responseJSON{ response in
                var success = false
                var comics = [Comic]()
                switch response.result {
                case .Success(let value):
                    log.verbose("Raw json value is ***: \(value)")
                    if let value = response.result.value {
                        log.debug("Raw json value is: \(value)")
                        let json = JSON(value)
                        log.verbose("First JSON record sample is: \(json["data"].arrayValue[0].dictionaryValue["Comic"])")
                        let jsonParser = JSONParser()
                        comics = jsonParser.parseComics(json)
                        success = true
                        log.debug("comics.count: \(comics.count)")
                        
                    }
                case .Failure(let error):
                    log.error("Failure fetching Comics: \(error)")
                    
                }
                // Call our completion handler
                completion(success: success, Comics: comics)
        }
        
        
        
        
        
        
}

}
