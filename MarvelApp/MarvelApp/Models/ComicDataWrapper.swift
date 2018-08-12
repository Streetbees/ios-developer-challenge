//
//  ComicDataWrapper.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation

struct ComicDataWrapper: Decodable {
    
    // (int, optional): The HTTP status code of the returned result.
    let code: Int?
    // (string, optional): A string description of the call status.
    let status: String?
    // (string, optional): The copyright notice for the returned result.
    let copyright: String?
    //(ComicDataContainer, optional): The results returned by the call.
    let data: ComicDataContainer?
  
}
