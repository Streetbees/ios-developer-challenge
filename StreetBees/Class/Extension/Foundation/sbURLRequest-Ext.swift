//
//  sbURLRequest-Ext.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


extension URLRequest
{
    static let percentEncodings: [String:String] =
    [
        "," : "%2C"
    ]
    
    static func resource(path: String,
                         queryItems: [URLQueryItem] = [],
                         isSecure: Bool = true) -> URLRequest?
    {
        var components: URLComponents = isSecure
            ? URLComponents.secured(path: path) : URLComponents.basic(path: path)
        
        if queryItems.count > 0
        {
            components.queryItems = queryItems
            
            for (key, value) in URLRequest.percentEncodings
            {
                components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: key, with: value)
            }
        }
        
        guard let url = components.url else
        { return nil }
        
        return URLRequest(url: url)
    }
}

