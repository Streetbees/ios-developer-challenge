//
//  HTTPHelper.swift
//  MarvelMeUp
//
//  Created by Dimitar Chakarov on 5/23/16.
//  Copyright © 2016 JI Apps Ltd. All rights reserved.
//

import Foundation

enum HTTPRequestAuthType {
    case HTTPBasicAuth(String, String)
    case HTTPTokenAuth(String)
    case None
}

enum HTTPRequestContentType {
    case HTTPJsonContent
    case HTTPMultipartContent
    case HTTPFormContent
}

struct HTTPHelper {
    var baseUrl: String

    func buildRequest(path: String!, method: String, authType: HTTPRequestAuthType,
                      requestContentType: HTTPRequestContentType = .HTTPJsonContent, requestBoundary: String = "", requestParameters: [String: String] = [:]) -> NSMutableURLRequest {

        let requestURL = NSURL(string: "\(baseUrl)/\(path)")
        let request = NSMutableURLRequest(URL: requestURL!)

        request.HTTPMethod = method
        switch requestContentType {
        case .HTTPJsonContent:
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        case .HTTPMultipartContent:
            let contentType = "multipart/form-data; boundary=\(requestBoundary)"
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        case .HTTPFormContent:
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            if requestParameters.count > 0 {
                request.HTTPBody = httpBodyForParamsDictionary(requestParameters).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            }
        }

        switch authType {
        case .HTTPBasicAuth(let username, let password):
            let basicAuthString = "\(username):\(password)"
            let utf8str = basicAuthString.dataUsingEncoding(NSUTF8StringEncoding)
            let base64EncodedString = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            request.addValue("Basic \(base64EncodedString!)", forHTTPHeaderField: "Authorization")
        case .HTTPTokenAuth(let authToken):
            // Set Authorization header
            request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        case .None:
            break
        }

        return request
    }

    func sendRequest(request: NSURLRequest, completion:(NSData!, NSError!) -> Void) -> () {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(data, error)
                })
                return
            }

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let httpResponse = response as! NSHTTPURLResponse

                if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                    completion(data, nil)
                } else {
                    completion(data, NSError(domain: "HTTPHelperError", code: httpResponse.statusCode, userInfo: nil))
                }
            })
        }

        // start the task
        task.resume()
    }

    func httpBodyForParamsDictionary(params: [String: String]) -> String {
        var paramsArray:[String] = []
        for (key, obj) in params {
            let str = obj.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
            paramsArray.append("\(key)=\(str!)")
        }
        if paramsArray.count > 0 {
            return paramsArray.joinWithSeparator("&")
        }
        return ""
    }
    
}
