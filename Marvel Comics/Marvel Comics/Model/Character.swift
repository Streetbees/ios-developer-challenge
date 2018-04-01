//
//  Character.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation

struct MarvelCharacter: Decodable {
  let id: Int
  let name: String
  let thumbnail: Image
  
  enum CodingKeys: String, CodingKey {
    case id, name, thumbnail
  }
}
