//
//  HomeViewControllerTests.swift
//  Marvel ComicsTests
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import XCTest
import Nimble

@testable import Marvel_Comics
class HomeViewControllerTests: XCTestCase {
  private var rootViewController: HomeViewController!
  private var topLevelUIUtilities: TopLevelUIUtilities<HomeViewController>!
  
  override func setUp() {
    super.setUp()
    let myViewController = HomeViewController(apiService: MockAPIService())
    rootViewController = myViewController
    topLevelUIUtilities = TopLevelUIUtilities<HomeViewController>()
    topLevelUIUtilities.setupTopLevelUI(withViewController: rootViewController)
  }
  
  override func tearDown() {
    rootViewController = nil
    topLevelUIUtilities.tearDownTopLevelUI()
    topLevelUIUtilities = nil
    super.tearDown()
  }
}
