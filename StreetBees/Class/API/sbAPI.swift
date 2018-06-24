//
//  sbAPI.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


enum APIPath: String
{
    case comics = "v1/public/comics"
}

enum APISecurityKey: String
{
    case `private` = "marvel api private key required here"
    case `public` = "marvel api public key required here"
}

enum APIKeys: String
{
    case data, results
}

class API
{
    class func hash(_ ts: Double) -> String
    { return ts.description + APISecurityKey.private.rawValue + APISecurityKey.public.rawValue }
}

