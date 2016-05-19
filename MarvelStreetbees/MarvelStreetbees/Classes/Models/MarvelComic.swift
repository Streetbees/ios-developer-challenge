//
//  Comic.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 18/05/16.
//  Copyright © 2016 MarvelStreetbees. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyDropbox



struct MarvelComic: Mappable {
    var id: Int?
    var digitalId: Int?
    var title: String?
    var issueNumber: Int?
    var variantDescription: String?
    var description: String?
    var modified: NSDate?
    var isbn: String?
    var upc: String?
    var ean: String?
    var issn: String?
    var format: String?
    var pageCount: Int?
    var textObjects: [String?]?
    var resourceURI: String?
    var thumbnail: MarvelImage?
    
    
    init?(_ map: Map) {
        
    }
    
    init(fromFile: Files.Metadata) {

        var newImage = MarvelImage()
        newImage.localPath = Constants.Settings.kMarvelDropboxFolder + "/" + fromFile.name
        newImage.localName = fromFile.name
        
        thumbnail = newImage
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        id                   <- map["id"]
        digitalId            <- map["digitalId"]
        title                <- map["title"]
        issueNumber          <- map["issueNumber"]
        variantDescription   <- map["variantDescription"]
        description          <- map["description"]
        modified             <- map["modified"]
        isbn                 <- map["isbn"]
        upc                  <- map["upc"]
        ean                  <- map["ean"]
        issn                 <- map["issn"]
        format               <- map["format"]
        pageCount            <- map["pageCount"]
        textObjects          <- map["textObjects"]
        resourceURI          <- map["resourceURI"]
        thumbnail            <- map["thumbnail"]
    }
    
    init() {
    }
}

struct ResponseComicsList: Mappable {
    var list: [MarvelComic]?
    var offset: Int?
    var limit: Int?
    var total: Int?
    var count: Int?
    
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        list      <- map["results"]
        offset      <- map["offset"]
        limit      <- map["limit"]
        total      <- map["total"]
        count      <- map["count"]
    }
    
    static func parseJSON(json: AnyObject) throws -> ResponseComicsList {
        
        guard let result = Mapper<ResponseComicsList>().map(json) else {
            throw NetworkError.InvalidDataForParsing
        }
        
        return result
    }
}

struct ComicsListRootResponse: Mappable {
    var code: Int?
    var status: String?
    var copyright: String?
    var attributionText: String?
    var attributionHTML: String?
    var etag: String?
    var data: ResponseComicsList?
    
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        code      <- map["code"]
        status      <- map["status"]
        copyright      <- map["copyright"]
        attributionText      <- map["attributionText"]
        attributionHTML      <- map["attributionHTML"]
        etag      <- map["etag"]
        data      <- map["data"]
    }
    
    static func parseJSON(json: AnyObject) throws -> ComicsListRootResponse {
        
        guard let result = Mapper<ComicsListRootResponse>().map(json) else {
            throw NetworkError.InvalidDataForParsing
        }
        
        return result
    }
}