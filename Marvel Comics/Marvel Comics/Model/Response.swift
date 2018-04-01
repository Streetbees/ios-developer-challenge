//
//  Response.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation

struct Response<T: Decodable>: Decodable {
  let code: Int
  let status: String
  let etag: String
  let data: MarvelData<T>
  
  enum CodingKeys: String, CodingKey {
    case code, status, etag, data
  }
}
