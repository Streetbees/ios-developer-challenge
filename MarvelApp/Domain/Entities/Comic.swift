//
//  Comics.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 25/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation

struct Comic: Codable, Equatable {
    
    let id: Int
    let digitalId: Int
    let title: String
    let issueNumber: Int
    let variantDescription: String
    let description: String?
    let modified: Date
    let format: String
    let pageCount: Int
    let resourceURI: String
    let thumbnail: ComicImage
    let images: [ComicImage]
    
}



