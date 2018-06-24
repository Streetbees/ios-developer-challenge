//
//  sbURLComponents-Ext.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


extension URLComponents
{
    static func basic(path: String,
                      scheme: String? = nil) -> URLComponents
    {
        var components: URLComponents = URLComponents()
        components.scheme = scheme ?? HTTPScheme.http.rawValue
        components.host = Environment.host
        components.path = path
        
        return components
    }
    
    static func secured(path: String) -> URLComponents
    { return URLComponents.basic(path: path, scheme: HTTPScheme.https.rawValue) }
}

