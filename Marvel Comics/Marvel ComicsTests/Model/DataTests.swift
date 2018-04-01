//
//  DataTests.swift
//  Marvel ComicsTests
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import XCTest
import Nimble

@testable import Marvel_Comics
class DataTests: XCTestCase {
  
  func testDataComicDecodeWithValidData() {
    let json = """
      {
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
    """.data(using: .utf8)!
    
    let marvelData = try? JSONDecoder().decode(MarvelData<MarvelComic>.self, from: json)
    
    expect(marvelData).toNot(beNil())
    expect(marvelData?.results).toNot(beNil())
    expect(marvelData?.results.count).to(equal(1))
  }
  
  func testDataCharacterDecodeWithValidData() {
    let json = """
      {
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
    """.data(using: .utf8)!
    
    let marvelData = try? JSONDecoder().decode(MarvelData<MarvelCharacter>.self, from: json)
    
    expect(marvelData).toNot(beNil())
    expect(marvelData?.results).toNot(beNil())
    expect(marvelData?.results.count).to(equal(1))
  }
}
