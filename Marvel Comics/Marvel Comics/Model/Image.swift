//
//  Image.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation

struct Image: Decodable {
  
  enum ImageVariant : CustomStringConvertible {
    case portraitFantastic
    
    case standardSmall
    case standardFantastic
    
    var description : String {
      switch self {
      case .portraitFantastic: return "portrait_fantastic"
      case .standardSmall: return "standard_small"
      case .standardFantastic: return "standard_fantastic"
      }
    }
  }
  
  let path: String
  let fileExtension: String
  
  enum CodingKeys: String, CodingKey {
    case path
    case fileExtension = "extension"
  }
  
  func getImageURL(_ variant: ImageVariant) -> URL? {
    return URL(string: securePath(path) + "/" + variant.description + "." + fileExtension)
  }
}

extension Image {
  func securePath(_ path: String) -> String {
    if path.hasPrefix("http://") {
      let range = path.range(of: "http://")
      var newPath = path
      if let range = range {
        newPath.removeSubrange(range)
      }
      return "https://" + newPath
    } else {
      return path
    }
  }
}
