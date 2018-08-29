//
//  ComicParser.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 26/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation

struct ComicParser {
    
    private var parser: JSONParserProtocol
    
    init(parser: JSONParserProtocol) {
        self.parser = parser
    }
    
    func decode(data: Data) throws -> PayloadWrapper<Comic> {
        
        parser.decoder.dateDecodingStrategy = .iso8601
        
        do {
            return try parser.decode(PayloadWrapper<Comic>.self, from: data)
        } catch let error {
            throw error
        }
    }
    
    //Not Used
    func encode(object: Comic) throws -> Data {
        
        do {
            return try parser.encode(object)
        } catch let error {
            throw error
        }
    }
}

//                let comicParser = ComicParser(parser: JSONParser())
//                var parsedData: PayloadWrapper<Comic>? = nil
//                var parseError: Error? = nil
//                do {
//                    parsedData = try comicParser.decode(data: response.data!)
//                } catch let error {
//                    parseError = error
//                }
