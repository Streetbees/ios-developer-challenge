//
//  Router.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
  
  case requestComics(Int)
  case requestCharacters(Int)
  
  private static let baseURLString = "https://gateway.marvel.com/v1/public"
  private static let pageSize = 50
  private static let issueNumber = "issueNumber"
  
  var method: HTTPMethod {
    return .get
  }
  
  var path: String {
    switch self {
    case .requestComics:
      return "/comics"
    case .requestCharacters(let id):
      return "/comics/\(id)/characters"
    }
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try Router.baseURLString.asURL()
    
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    let timestamp = Date().timeIntervalSince1970.description
    
    var params: Parameters = ["ts": timestamp]
    
    if let apiKeys = ConfigProvider.getAPIKeys(), let publicKey = apiKeys["publicKey"], let privateKey = apiKeys["privateKey"] {
      params["apikey"] = publicKey
      params["hash"] = CryptoHasher.createHash(timestamp, privateKey, publicKey)
    }
    
    switch self {
    case .requestComics(let offset):
      params["offset"] = offset
      params["orderBy"] = Router.issueNumber
      params["limit"] = Router.pageSize
    default: break
    }
    
    return try URLEncoding.default.encode(urlRequest, with: params)
  }
}
