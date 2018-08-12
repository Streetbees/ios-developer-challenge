//
//  Comic.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation

struct Comic: Decodable {
    
    // (int, optional): The unique ID of the comic resource.
    let uniqueID: Int?
    // (string, optional): The canonical title of the comic.
    let title: String?
    // (string, optional): If the issue is a variant (e.g. an alternate cover, second printing, or director’s cut), a text description of the variant.
    let variantDescription: String?
    // (string, optional): The preferred description of the comic.
    let description: String?
    // (Date, optional): The date the resource was most recently modified.
    let modified: String?
    // (string, optional): The canonical URL identifier for this resource.
    let resourceURI: String?
    // (Array[Url], optional): A set of public web site URLs for the resource.
    let urls: [ComicUrl]?
    // (Array[ComicSummary], optional): A list of collections which include this comic (will generally be empty if the comic's format is a collection).
    let collections: [ComicSummary]?
    // (Array[ComicSummary], optional): A list of issues collected in this comic (will generally be empty for periodical formats such as "comic" or "magazine").
    let collectedIssues: [ComicSummary]?
    // (Array[ComicDate], optional): A list of key dates for this comic.
    let dates: [ComicDate]?
    // (Array[ComicPrice], optional): A list of prices for this comic.
    let prices: [ComicPrice]?
    // (Image, optional): The representative image for this comic.
    let thumbnail: ComicImage?
    // (Array[Image], optional): A list of promotional images associated with this comic.
    let images: [ComicImage]?
    
    private enum CodingKeys : String, CodingKey {
        
        case uniqueID = "id",
        title,
        variantDescription,
        description,
        modified,
        resourceURI,
        urls,
        collections,
        collectedIssues,
        dates,
        prices,
        thumbnail,
        images
    }
}
