//
//  ComicDataContainer.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation

struct ComicDataContainer: Decodable {
    
    // (int, optional): The requested offset (number of skipped results) of the call.
    let offset: Int?
    // (int, optional): The requested result limit.
    let limit: Int?
    // (int, optional): The total number of resources available given the current filter set.
    let total: Int?
    // (int, optional): The total number of results returned by this call.
    let count: Int?
    // (Array[Comic], optional): The list of comics returned by the call
    let results: [Comic?]?
}
