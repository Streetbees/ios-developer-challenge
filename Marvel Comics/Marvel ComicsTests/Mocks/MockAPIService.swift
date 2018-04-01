//
//  MockAPIService.swift
//  Marvel ComicsTests
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation

@testable import Marvel_Comics
class MockAPIService: APIService {
  
  override init() {
    super.init()
  }
  
  override func requestComics(offset: Int, _ completion: @escaping ComicsResultSuccess, _ failure: @escaping ServiceFailure) {
    let json = """
      {
        "code": 200,
        "status": "Ok",
        "etag": "123abc",
        "data": {
            "offset": 0,
            "limit": 5,
            "total": 1,
            "count": 1,
            "results": [{
              "id": 123,
              "title": "X-Men Unlimited",
              "description": "Test Description",
              "thumbnail": {
                "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
                "extension": "jpg"
              }
            }]
        }
      }
    """.data(using: .utf8)!
    
    let response = try? JSONDecoder().decode(Response<MarvelComic>.self, from: json)
    
    completion(response!)
  }
  
  override func requestCharacters(comicId: Int, _ completion: @escaping CharacterResultSuccess, _ failure: @escaping ServiceFailure) {
    let json = """
      {
        "code": 200,
        "status": "Ok",
        "etag": "123abc",
        "data": {
            "offset": 0,
            "limit": 5,
            "total": 1,
            "count": 1,
            "results": [{
              "id": 123,
              "name": "Hulk",
              "thumbnail": {
                "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
                "extension": "jpg"
              }
            }]
        }
      }
    """.data(using: .utf8)!
    
    let response = try? JSONDecoder().decode(Response<MarvelCharacter>.self, from: json)
    completion(response!)
  }
  
  func requestCharactersWithError(_ failure: @escaping ServiceFailure) {
    self.requestComics(offset: 0, { (_) in
    }) { (error) in
      failure(error)
    }
  }
}
