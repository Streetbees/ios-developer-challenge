//
//  Parser.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 26/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation

protocol Parser {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

protocol JSONParserProtocol: Parser {
    var decoder: JSONDecoder { get set }
    var encoder: JSONEncoder { get set }
}

struct JSONParser: JSONParserProtocol {
    
    public init() {}
    
    var decoder: JSONDecoder = JSONDecoder()
    var encoder: JSONEncoder = JSONEncoder()
    
    public func decode<T>(_ object: T.Type, from data: Data) throws -> T where T: Decodable {
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch let error {
            throw error
        }
    }
    
    //Not used
    public func encode<T>(_ value: T) throws -> Data where T: Encodable {

        do {
            return try encoder.encode(value)
        } catch let error {
            throw error
        }
    }
}
