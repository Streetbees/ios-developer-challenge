//
//  MarvelAPIClient.swift
//  MarvelMeUp
//
//  Created by Dimitar Chakarov on 5/23/16.
//  Copyright © 2016 JI Apps Ltd. All rights reserved.
//

import Foundation
import UIKit

enum ParseError: ErrorType {
    case InvalidFormat
    case FieldMissing(String)
}

class APIClient {

    static let sharedInstance = APIClient()
    let httpHelper = HTTPHelper(baseUrl: Config.marvelBaseUrl)

    func fetchComics(completion: (inner: () throws -> (count: Int, comics: [[String: AnyObject]])) -> Void) {
        let limit = 100
        let ts = NSDate().timeIntervalSince1970.description
        let str = ts + Config.marvelPrivateKey + Config.marvelPublicKey
        let hash = toHexString(md5(Array(str.utf8)))
        let orderBy = "-onsaleDate"
        let apiKey = Config.marvelPublicKey
        let request = httpHelper.buildRequest("comics?noVariants=true&orderBy=\(orderBy)&limit=\(limit)&apikey=\(apiKey)&ts=\(ts)&hash=\(hash)", method: "GET", authType: .None)
        httpHelper.sendRequest(request) { (data, error) in
            do {
                guard error == nil else {
                    throw error
                }
                guard let
                    responseDict = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject],
                    code = responseDict["code"] as? Int,
                    data = responseDict["data"] as? [String: AnyObject],
                    total = data["total"] as? Int,
                    comics = data["results"] as? [[String: AnyObject]]
                else {
                    throw ParseError.InvalidFormat
                }

                guard code == 200 else {
                    let apiError = NSError(domain: "APIClientError", code: code, userInfo: nil)
                    throw apiError
                }

                completion(inner: { return (total, comics) })
            } catch let error {
                completion(inner: { throw error })
            }
        }
    }
    
}

