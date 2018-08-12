//
//  ComicSummary.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation

struct ComicSummary: Decodable {
    
    // (string, optional): The path to the individual comic resource.
    let resourceURI: String?
    // (string, optional): The canonical name of the comic.
    let name: String?

}



