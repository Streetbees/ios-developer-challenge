//
//  APIServiceTests.swift
//  Marvel ComicsTests
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//


import XCTest
import Nimble
import Mockingjay

@testable import Marvel_Comics
class APIServiceTests: XCTestCase {
  
  private var apiService: MockAPIService!
  
  override func setUp() {
    super.setUp()
    apiService = MockAPIService()
  }
  
  func testRequestComicsSuccess() {
    
    var expectedComics: [MarvelComic]?
    
    apiService.requestComics(offset: 0, { (response) in
      expectedComics = response.data.results
    }) { (error) in
      XCTFail(error.localizedDescription)
    }
    
    expect(expectedComics).toEventuallyNot(beNil())
  }
  
  func testRequestCharactersSuccess() {
    
    var expectedCharacters: [MarvelCharacter]?
    
    apiService.requestCharacters(comicId: 123, { (response) in
      expectedCharacters = response.data.results
    }) { (error) in
      XCTFail(error.localizedDescription)
    }
    
    expect(expectedCharacters).toEventuallyNot(beNil())
  }
}

