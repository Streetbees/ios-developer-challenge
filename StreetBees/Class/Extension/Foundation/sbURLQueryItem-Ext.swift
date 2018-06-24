//
//  sbURLQueryItem-Ext.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


extension URLQueryItem: JSONProvider
{
    static func load(contentsOfFile path: String) -> JSONObject?
    {
        guard let jsonObject = try? JSONSerialization.collect([CompilableKeys.queryItems.rawValue],
                                                              contentsOf: path) else
        { return nil }
        
        return jsonObject
    }
}

extension URLQueryItem: JSONCompilable
{
    enum CompilableKeys: String
    {
        case queryItems
        case apikey, ts, hash
    }
    
    static func compile(jsonObject: JSONObject) -> [URLQueryItem]
    {
        guard let collection = jsonObject[CompilableKeys.queryItems.rawValue] as? [JSONObject] else
        { return [] }
        
        var buffer: [URLQueryItem] = []
        
        for jsonObject in collection
        {
            guard let key = jsonObject.keys.first,
                let value = jsonObject.values.first as? String else
            { continue }
            
            buffer.append(URLQueryItem(name: key, value: String(value)))
        }
        
        let ts: Double = Date().timeIntervalSince1970
        buffer.append(URLQueryItem(name: CompilableKeys.apikey.rawValue, value: APISecurityKey.public.rawValue))
        buffer.append(URLQueryItem(name: CompilableKeys.ts.rawValue, value: ts.description))
        buffer.append(URLQueryItem(name: CompilableKeys.hash.rawValue, value: API.hash(ts).md5))
        
        return buffer
    }
}

