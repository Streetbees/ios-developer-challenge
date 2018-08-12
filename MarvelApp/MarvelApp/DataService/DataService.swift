//
//  DataService.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation
import Alamofire


class DataService {
    
    var delegate : MarvelDataServiceDelegate
    
    init(delegate: MarvelDataServiceDelegate) {
        self.delegate = delegate
    }
    

    // Fetching all the comics from API
    func fetchComicsFromAPI() {
        
        // Instantiate request with response completion handler
        Alamofire.request(requestUrl()).responseData { (responseData) in

            // Check response data conditions (Success/Failure)
            switch responseData.result {
                
            // If we have successfully received data from API
            case .success:
                
                // Unwrapping the actual json data from the responseData input
                guard let data = responseData.data else { return }
                
                do {
                    // Using native JSONDecoder class to desriallize and map json data into model objects
                    let comicDataWrapper = try JSONDecoder().decode(ComicDataWrapper.self, from: data)
                    // If decoding is successfull, call handleSuccess method with decoded model object
                    self.handleSuccess(comicDataWrapper: comicDataWrapper)
                    
                } catch let decoderError {
                    
                    print("Decoder Failed ", decoderError)
                    // If decoding is failure, call handleFailure method with decoder error
                    self.handleFailure(error: decoderError)
                    
                }

            // If fetching data from API failed
            case .failure(let error):
                
                print("Error in fetching comics ", error.localizedDescription)
                // Call handleFailure method with localizedDescription error
                self.handleFailure(error: error)

            }
            
        }

    }
    
    // Passing filled model objects to delegation object
    func handleSuccess(comicDataWrapper: ComicDataWrapper) {
        self.delegate.didSucceedToFetchComics(withComicDataWrapper: comicDataWrapper)
    }
    
    // Passing occured error during the fetch/parse API data to delegation object
    func handleFailure(error: Error) {
        self.delegate.didFailToFetchComics(withError: error)
    }
}


//MARK:- Request URL Generation
extension DataService {
    
    // Generating a proper request url
    func requestUrl() -> URL! {
        
        // As API required to get a hash string as a parameter in request url, we generate that by calling getHash (Factory) method.
        let hash = Hash.getHash()
        
        // Concatinating API constants to structure the base request url
        let apiFullAddress =
            k.API.BASE_URL
                + k.API.VERSION
                + k.API.ACCESS
                + k.API.END_POINT
        
        // Concatinating Parameter constants to structure required parameters for API url request
        let parameters = "?format=\(k.API.PARAMETERS.FORMAT)&"
            + "formatType=\(k.API.PARAMETERS.FORMAT_TYPE)&"
            + "limit=\(k.API.PARAMETERS.LIMIT)&"
            + "apikey=\(k.API.PARAMETERS.PUBLIC_KEY)&"
            // Using hash object timestamp
            + "ts=\(hash.timestamp!)&"
            // Using hashed string
            + "hash=\(hash.hashString!)"
        
        // Concatinating and returning API full address and required parameters by API which structes final url address
        return URL(string: apiFullAddress + parameters)!
    }
}
