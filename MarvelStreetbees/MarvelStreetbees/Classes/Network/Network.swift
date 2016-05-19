//
//  MenuViewController.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 10/01/16.
//  Copyright © 2016 MarvelStreetbees. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

import RxSwift

// ==============================================================
// define Alamofire Router
enum Router: Alamofire.URLRequestConvertible {
    static var debugNetworking = true
    static var baseURL = NSURL(string: "http://gateway.marvel.com/v1/public/")!
    static var authKey: String? {
        didSet {
            if Router.debugNetworking {
                print("Router - new authKey: \(authKey)")
            }
        }
    }
    case GetComicsList(pageIndex: Int, pageSize: Int)
    
    // ----------------------------
    
    var URL: NSURL {
        return Router.baseURL.URLByAppendingPathComponent(route.path)
    }
    
    var method: Alamofire.Method {
        switch self {
        case .GetComicsList:
            return .GET
        }
    }
    
    // computed route property that returns a tuple to
    // translate from our enum cases into URL path and parameter values.
    var route: (path: String, parameters: [String : AnyObject]?) {
        switch self {
        case .GetComicsList(let pageIndex, let pageSize):
            return ("comics", ["limit": pageSize, "offset": pageIndex * pageSize, "orderBy": "-onsaleDate"])
        }
    }
    
    // computed property that encodes our URL and parameters into an NSMutableURLRequest
    var URLRequest: NSMutableURLRequest {
        
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = method.rawValue
        
        let timestamp = "\(NSDate().timeIntervalSince1970)"
        
        mutableURLRequest.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        var parameters = [String : AnyObject]()
        if let params = route.parameters {
            parameters = params
        }
        
        let hashString = "\(timestamp)\(Constants.Settings.kMarvelPrivateKey)\(Constants.Settings.kMarvelPublicKey)"
        let hash = hashString.md5()
        
        parameters["apikey"] = Constants.Settings.kMarvelPublicKey
        parameters["ts"] = timestamp
        parameters["hash"] = hash
        
        let finalRequest = Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        
        if Router.debugNetworking {
            print ("Parameters: \(route.parameters)")
            print("Network request: \(finalRequest)")
            print("Network request header: \(finalRequest.allHTTPHeaderFields)")
            print("Network request body: \(finalRequest.HTTPBody)")
        }
        
        return finalRequest
    }
}



// ===============================================================
class NetworkManager {
    
    static var debugNetworking = false
    
    // Observable<(AnyObject, [String:String])>
    class func requestJSON(router: Router) -> Observable<AnyObject> {
        
        return Observable.create { observer in
            
            let request = Alamofire.request(router)
                .responseString(completionHandler: { response in
                    let responseString = response.result.value
                    print("Response String: \(responseString!)")
                })

                .responseJSON(completionHandler: {
                    response in
                    
                    print("response \(response.response)") // URL response
                    print("result \(response.result)")
                    
                    if NetworkManager.debugNetworking {
                        // prints detailed description of all response properties
                        debugPrint(response)
                        
                        // print(response.request)  // original URL request
                        // print(response.response) // URL response
                        // print(response.data)     // server data
                        // print(response.result)   // result of response serialization
                    }
                    switch response.result {
                    case .Success(let value):
                        
                        // print json ok
                         let sss = SwiftyJSON.JSON(value)
                         print("printing json directly from response: \(sss)")
                        
                        // send value
                        observer.on(.Next(value))
                        observer.on(.Completed)
                        
                    case .Failure(let error):
                        observer.on(.Error(NetworkError.ServerConnectionProblems(message: error.localizedDescription)))
                    }
                    
                })
            
            request.resume()
            
            return AnonymousDisposable {
                request.cancel()
            }
        }
    }
    
    class func requestSwiftyJSON(router: Router) -> Observable<SwiftyJSON.JSON> {
        return NetworkManager.requestJSON(router).map({ value in
            return SwiftyJSON.JSON(value)
        })
    }
    
    
    class func requestImage(imageURL: String) -> Observable<UIImage> {
        
        return Observable.create { observer in
            
            let request = Alamofire.request(.GET, imageURL).responseData(completionHandler: { response in
                switch response.result {
                case .Success(let data):
                    guard let image = UIImage(data: data) else {
                        observer.on(.Error(NetworkError.IncorrectDataReturned))
                        return
                    }
                    
                    observer.on(.Next(image))
                    observer.on(.Completed)
                case .Failure(let error):
                    observer.on(.Error(NetworkError.ServerConnectionProblems(message: error.localizedDescription)))
                }
                
            })
            
            request.resume()
            
            return AnonymousDisposable {
                request.cancel()
            }
        }
    }
}