//
//  ComicTests.swift
//  Marvel ComicsTests
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import XCTest
import Nimble

@testable import Marvel_Comics
class ComicTests: XCTestCase {
  
  func testComicDecodeWithValidData() {
    let json = """
      {
        "id": 123,
        "title": "X-Men Unlimited",
        "description": "Test Description",
        "thumbnail": {
          "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
          "extension": "jpg"
        }
      }
    """.data(using: .utf8)!
    
    let comic = try? JSONDecoder().decode(MarvelComic.self, from: json)
    
    expect(comic).toNot(beNil())
    expect(comic?.thumbnail).toNot(beNil())
    expect(comic?.id).to(equal(123))
    expect(comic?.title).to(equal("X-Men Unlimited"))
    expect(comic?.description).to(equal("Test Description"))
  }
}
