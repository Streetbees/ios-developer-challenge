//
//  Comic.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation

struct MarvelComic: Decodable {
  let id: Int
  let title: String
  let description: String?
  let thumbnail: Image
  
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case description
    case thumbnail
  }
}
