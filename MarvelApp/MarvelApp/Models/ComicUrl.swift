//
//  ComicUrl.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation

struct ComicUrl: Decodable {
    
    // (string, optional): A text identifier for the URL.
    let type: String?
    // (string, optional): A full URL (including scheme, domain, and path).
    let url: String?
}
