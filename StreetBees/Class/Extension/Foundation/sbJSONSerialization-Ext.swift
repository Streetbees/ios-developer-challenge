//
//  sbJSONSerialization-Ext.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


enum JSONSerializationError: Error
{
    case file
    case data
    case json
    case key
    case failed
}

public typealias JSONObject = [String:Any]

protocol JSONProvider
{
    static func load(contentsOfFile path: String) -> JSONObject?
}

protocol JSONCompilable
{
    associatedtype ReturnType
    
    static func compile(jsonObject: JSONObject) -> ReturnType
}

protocol JSONDataLoading
{
    func load(data: Data)
}

protocol JSONFileLoading
{
    func load(contentsOfFile path: String)
}

extension JSONSerialization
{
    static func object(with data: Data?) throws -> JSONObject
    {
        guard let data = data,
            !data.isEmpty else
        { throw JSONSerializationError.data }
        
        do
        {
            let result = try JSONSerialization.jsonObject(with: data,
                                                          options: .allowFragments) as? JSONObject ?? [:]
            return result
        }
        catch _ { throw JSONSerializationError.failed }
    }
    
    static func collect(_ keys: [String],
                        with data: Data) throws -> JSONObject
    {
        if data.isEmpty
        { throw JSONSerializationError.data }
        
        do
        {
            let jsonObject = try JSONSerialization.object(with: data)
            var buffer: JSONObject = [:]
            
            for key in keys
            {
                guard let result = jsonObject[key] else
                { throw JSONSerializationError.key }
                
                buffer[key] = result
            }
            return buffer
        }
        catch _ { throw JSONSerializationError.json }
    }
    
    static func collect(_ keys: [String],
                        contentsOf path: String) throws -> JSONObject
    {
        do
        {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path),
                                       options: [.uncached, .alwaysMapped]) else
            { throw JSONSerializationError.data }
            
            guard let result = try? JSONSerialization.collect(keys, with: data) else
            { throw JSONSerializationError.json }
            
            return result
        }
        catch { throw JSONSerializationError.failed }
    }
}

