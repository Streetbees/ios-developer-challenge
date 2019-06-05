//
//  MarvelAPI.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 27/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation
import Alamofire

struct PayloadWrapper<T: Codable>: Codable {
    
    let code: Int
    let status: String
    let etag: String
    let data: PayloadContainer<T>
}

struct PayloadContainer<T: Codable>: Codable {
    
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [T]
}

typealias NetworkRequestCompletionHandler = (_ data: Data?, _ error: Error?) -> Void

protocol MarvelAPI {
    func getComics(request: URLRequestConvertible, completionHandler: @escaping NetworkRequestCompletionHandler)
}


