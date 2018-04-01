//
//  ImageTests.swift
//  Marvel ComicsTests
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import XCTest
import Nimble

@testable import Marvel_Comics
class ImageTests: XCTestCase {
  
  func testImageDecodeWithValidData() {
    let json = """
      {
        "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
        "extension": "jpg",
      }
    """.data(using: .utf8)!
    
    let image = try? JSONDecoder().decode(Image.self, from: json)
    
    expect(image).toNot(beNil())
    expect(image?.path).to(equal("http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available"))
    expect(image?.fileExtension).to(equal("jpg"))
  }
  
  func testImageSecurePathWithNonSecurePath() {
    let image = Image(path: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available", fileExtension: "jpg")
    
    let path = image.securePath(image.path)

    let expectedPath = "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available"
    
    expect(path).to(equal(expectedPath))
  }
  
  func testImageSecurePathWithSecurePath() {
    
    let image = Image(path: "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available", fileExtension: "jpg")
    
    let path = image.securePath(image.path)

    let expectedPath = "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available"
    
    expect(path).to(equal(expectedPath))
  }
  
  func testGetImageURL() {
    let image = Image(path: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available", fileExtension: "jpg")
    
    let url = image.getImageURL(.standardSmall)
    
    let expectedURL = URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available/standard_small.jpg")
    
    expect(url).to(equal(expectedURL))
  }
}
