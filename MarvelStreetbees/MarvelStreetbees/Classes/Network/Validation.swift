//
//  MenuViewController.swift
//  SportXast
//
//  Created by Danut Pralea on 10/01/16.
//  Copyright © 2016 SportXast. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper
import RxSwift

extension NetworkManager {
    
    // ============================================================================
    // MARK: Validations
    // ============================================================================
    class func validateResponseRoute(json: SwiftyJSON.JSON) -> Observable<SwiftyJSON.JSON> {
        
        return Observable.create { observer in
                    
            guard let success = json["success"].bool where success == true else {
                observer.on(.Error(NetworkError.InternalServerError(message: "Email address could not be found")))
                return NopDisposable.instance
            }
            
            observer.on(.Next(json))
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }
    
    class func validateResponseLogin(json: SwiftyJSON.JSON) -> Observable<SwiftyJSON.JSON> {
        
        return Observable.create { observer in
            
            if let error = json["error"].bool where error == true {
                if let message = json["message"].string {
                    // print(message)
                    observer.on(.Error(NetworkError.InternalServerError(message: message)))
                }
            }
            else {
                observer.on(.Next(json))
                observer.on(.Completed)
            }
            
            return NopDisposable.instance
        }
    }
    
    
    class func validateResponse(value: AnyObject) -> Observable<AnyObject> {
        
        return Observable.create { observer in
            
            let json = SwiftyJSON.JSON(value)
            
            if let error = json["error"].bool where error == true {
                if let message = json["message"].string {
                    observer.on(.Error(NetworkError.InternalServerError(message: message)))
                }
                else {
                    observer.on(.Error(NetworkError.InternalServerError(message: "unknown error")))
                }
            }
            else {
                observer.on(.Next(value))
                observer.on(.Completed)
            }
            
            return NopDisposable.instance
        }
        
    }
    
    
    
        
}