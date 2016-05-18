//
//  MarvelImage.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 18/05/16.
//  Copyright © 2016 Parhelion Software. All rights reserved.
//

import Foundation
import ObjectMapper

enum MarvelImageResolution {
    case Small
    case Medium
    case Large
    
    var resolutionName : String {
        switch self {
        case .Small:
            return "/standard_small"
        case .Medium:
            return "/standard_medium"
        case .Large:
            return "/standard_large"
        }
    }
}


struct MarvelImage: Mappable {
    var path: String?
    var ext: String?
    
    
    init?(_ map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        path <- map["path"]
        ext  <- map["extension"]
    }
    
    init() {
        
    }
    
    func imageURLString(resolution: MarvelImageResolution) -> String? {
        guard let path = path, let ext = ext else {
            return nil
        }
        return path + resolution.resolutionName + ".\(ext)"
    }
}