//
//  Image.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation

struct ComicImage: Decodable {
    
    // (string, optional): The directory path of to the image.
    let path: String?
    //  (string, optional): The file extension for the image.
    let imageExt: String?
    
    private enum CodingKeys : String, CodingKey {
        case path,
        imageExt = "extension"
    }
}
