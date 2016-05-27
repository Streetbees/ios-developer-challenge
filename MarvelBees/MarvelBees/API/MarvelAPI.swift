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
import SDWebImage
import AlamofireImage

// TODO, shift these

class MarvelAPI {
    
    static let sharedInstance = MarvelAPI()
    
    // MARK: - Properties - Constants
    static let MarvelPublicKey = "9be75bf4626446510afb05ce61a87743"
    static let MarvelPrivateKey = "1ccdaf259212de9f550d40348d291a79b1713c67"
    
    static let MarvelAPIVersion = "v1"
    let MarvelBaseURL = "http://gateway.marvel.com:80/\(MarvelAPIVersion)/public/"
    
    // MARK: - Notifications - Constants
    static let ComicFetchDidSucceedNotification = "ComicFetchDidSucceedNotification"
    static let ComicFetchDidFailNotification = "ComicFetchDidFailNotification"
    
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
    func fetchComics(offset:Int, completion: ((success: Bool, Comics: [Comic]) -> ())) {
        
        let comicsURL = "\(MarvelBaseURL)/comics"
        let authentication = Authentication()
        let hash = authentication.generateHash()
        log.debug("\(hash)")
        
        guard hash != "" else {
            log.error("Hash returned empty, please check keys")
            completion(success: false, Comics: [])
            return
        }
        
        let offset = offset
        let limit = 20
        
        // Add URL parameters
        let urlParameters: [String : AnyObject] = [
            "apikey":authentication.publicKey,
            "ts":authentication.timeStamp,
            "limit": limit,
            "offset": offset,
            "hash": hash,
            "orderBy":"-onsaleDate"
        ]
        
        // Fetch Request
        Alamofire.request(.GET, comicsURL, parameters: urlParameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    log.verbose("HTTP Response Body: \(response.data)")
                }
                else {
                    log.verbose("HTTP Request failed: \(response.result.error)")
                }
        }
        
        log.debug("comicsURL is: \(comicsURL)")
        Alamofire.request(.GET, comicsURL, parameters: urlParameters)
            .validate(statusCode: 200..<300)
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
                // Post a notification with login status
                let notification = (success ? MarvelAPI.ComicFetchDidSucceedNotification : MarvelAPI.ComicFetchDidFailNotification)
                // Call our completion handler
                completion(success: success, Comics: comics)
                NSNotificationCenter.defaultCenter().postNotificationOnMainThread(NSNotification(name: notification, object: nil))
        }
        
    }
    
    
    func replaceImageWithURLString(URLString: String, comic: Comic, imageToReplace: UIImageView, placeholderImage: UIImage) {
        if let cachedImage = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(comic.dropboxFileName) {
            imageToReplace.image = cachedImage
        }
        else {
            
            imageToReplace.af_setImageWithURL(NSURL(string: URLString)!, placeholderImage: placeholderImage, filter: nil, progress: nil, progressQueue: dispatch_get_main_queue(), imageTransition: .CrossDissolve(0.2), runImageTransitionIfCached: true) { (response) in
                if let data = response.data {
                    if let image = UIImage(data: data) {
                        SDImageCache.sharedImageCache().storeImage(image, forKey: comic.dropboxFileName, toDisk: true)
                    }
                }
            }
        }
        //
    }
    
}
