//
//  ComicsAPIManager.swift
//  Marvel
//
//  Created by Gabriel Massana on 18/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

import CoreNetworking
import CoreOperation

class ComicsAPIManager: APIManager {

    //MARK: - RetrieveComics

    /**
     Retrieve comics data from Marvel API.
     
     - parameter offset: the offset of data to be ask for.
     - parameter success: success callback to be called if the operation succed.
     - parameter failure: failure callback to be called if the operation fails.
     */
    class func retrieveComics(offset: String, success: NetworkingOnSuccess, failure: NetworkingOnFailure) {
        
        // Offset from Core Data
        let comicRequest: ComicsRequest = ComicsRequest.comicRequest()
        
        comicRequest.updateRequestWithEndpoint("/v1/public/comics", offset: offset)
        
        let task: CNMURLSessionDataTask = CNMSession.defaultSession().dataTaskFromRequest(comicRequest)
        
        task.onCompletion = { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if let data = data {
                
                do {
                    let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSDictionary
                    
                    let operation: ComicsParserOperation = ComicsParserOperation(comicsResponse: json, offset: offset)
                    operation.operationQueueIdentifier = LocalDataOperationQueueTypeIdentifier
                    
                    operation.onSuccess = { (result:AnyObject?) -> Void in
                        
                        success(result: nil)
                    }
                    
                    COMOperationQueueManager.sharedInstance().addOperation(operation)
                }
                catch
                {
                    print(error)
                    failure(error: nil)
                }
            }
            else
            {
                failure(error: error)
            }
        }
        
        task.resume()
    }
}
