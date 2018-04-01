//
//  ResponseTests.swift
//  Marvel ComicsTests
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import XCTest
import Nimble

@testable import Marvel_Comics
class ResponseTests: XCTestCase {
  
  func testDataComicDecodeWithValidData() {
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
    
    expect(response).toNot(beNil())
    expect(response?.data.results).toNot(beNil())
    expect(response?.data.results.count).to(equal(1))
    expect(response?.data.results.first?.title).to(equal("X-Men Unlimited"))
  }
  
  func testDataCharacterDecodeWithValidData() {
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
    
    expect(response).toNot(beNil())
    expect(response?.data.results).toNot(beNil())
    expect(response?.data.results.first?.name).to(equal("Hulk"))
  }
}
