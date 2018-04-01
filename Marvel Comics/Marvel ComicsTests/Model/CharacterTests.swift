//
//  CharacterTests.swift
//  Marvel ComicsTests
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import XCTest
import Nimble

@testable import Marvel_Comics
class CharacterTests: XCTestCase {
  
  func testComicDecodeWithValidData() {
    let json = """
      {
        "id": 123,
        "name": "Hulk",
        "thumbnail": {
          "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
          "extension": "jpg"
        }
      }
    """.data(using: .utf8)!
    
    let character = try? JSONDecoder().decode(MarvelCharacter.self, from: json)
    
    expect(character).toNot(beNil())
    expect(character?.thumbnail).toNot(beNil())
    expect(character?.id).to(equal(123))
    expect(character?.name).to(equal("Hulk"))
  }}
