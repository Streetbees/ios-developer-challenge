//
//  ComicDate.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation

struct ComicDate: Decodable {
    
    // (string, optional): A description of the date (e.g. onsale date, FOC date).
    let type: String?
    // (Date, optional): The date.
    let date: String?

}


