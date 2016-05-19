//
//  MarvelImage.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 18/05/16.
//  Copyright © 2016 MarvelStreetbees. All rights reserved.
//

import Foundation
import ObjectMapper

enum MarvelImageResolution {
    
    // Portrait
    case PortraitSmall
    case PortraitMedium
    case PortraitXLarge
    case PortraitFantastic
    case PortraitUncanny
    case PortraitIncredible
    
    // Standard
    case StandardSmall
    case StandardMedium
    case StandardLarge
    case StandardXLarge
    case StandardFantastic
    case StandardAmazing
    
    // Landscape
    case LandscapeSmall
    case LandscapeMedium
    case LandscapeLarge
    case LandscapeXLarge
    case LandscapeAmazing
    case LandscapeIncredible
    
    //Other
    case Detail
    case Full
    
    
    var resolutionName : String {
        switch self {
        case .PortraitSmall:
            return "/standard_small"
        case .PortraitMedium:
            return "/standard_medium"
        case .PortraitXLarge:
            return "/standard_large"
        case .PortraitFantastic:
            return "/standard_xlarge"
        case .PortraitUncanny:
            return "/standard_fantastic"
        case .PortraitIncredible:
            return "/standard_amazing"
            
        case .StandardSmall:
            return "/standard_small"
        case .StandardMedium:
            return "/standard_medium"
        case .StandardLarge:
            return "/standard_large"
        case .StandardXLarge:
            return "/standard_xlarge"
        case .StandardFantastic:
            return "/standard_fantastic"
        case .StandardAmazing:
            return "/standard_amazing"
            
        case .LandscapeSmall:
            return "/landscape_small"
        case .LandscapeMedium:
            return "/landscape_medium"
        case .LandscapeLarge:
            return "/landscape_large"
        case .LandscapeXLarge:
            return "/landscape_xlarge"
        case .LandscapeAmazing:
            return "/landscape_amazing"
        case .LandscapeIncredible:
            return "/landscape_incredible"
            
        case .Detail:
            return "/detail"
        case .Full:
            return ""
        }
    }
}


struct MarvelImage: Mappable {
    var path: String?
    var ext: String?
    
    var localPath: String?
    
    var localName: String?
    
    
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