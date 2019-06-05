//
//  ComicImage.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 26/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation

enum MarvelImageSizes: String {
    
    case portrait_small,
        portrait_medium,
        portrait_xlarge,
        portrait_fantastic,
        portrait_uncanny,
        portrait_incredible
}

struct ComicImage: Codable, Equatable {
    
    let path: String
    let imageExtension: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }
    
    func buildString(size: MarvelImageSizes) -> String {
        return "\(path)/\(size.rawValue).\(imageExtension)"
    }
}
