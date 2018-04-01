//
//  Data.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation

struct MarvelData<T: Decodable>: Decodable {
  let offset: Int
  let limit: Int
  let total: Int
  let count: Int
  let results: [T]
  
  enum CodingKeys: String, CodingKey {
    case offset, limit, total, count, results
  }
}
