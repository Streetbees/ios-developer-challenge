//
//  CryptoHasherTests.swift
//  Marvel ComicsTests
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import XCTest
import Nimble
import Mockingjay

@testable import Marvel_Comics
class CryptoHasherTests: XCTestCase {
  
  private var apiService: MockAPIService!
  
  override func setUp() {
    super.setUp()
    apiService = MockAPIService()
  }
  
  func testMD5Hash() {
    let timeStamp = Date().timeIntervalSince1970.description
    let privateKey = "asd123"
    let publicKey = "qwert123"
    
    let combined = timeStamp + privateKey + publicKey
    
    let hash = CryptoHasher.createHash(timeStamp, privateKey, publicKey)
    
    expect(combined).toNot(equal(hash))
  }
}
