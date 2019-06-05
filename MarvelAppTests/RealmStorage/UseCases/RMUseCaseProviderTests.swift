//
//  UseCaseProviderTests.swift
//  MarvelAppTests
//
//  Created by Rodrigo Cardoso on 28/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import XCTest
@testable import MarvelApp

class UseCaseProviderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_it_creates_comicUseCase() {
        let comicUseCase = RMUseCaseProvider(configuration: RealmTestsSetup().setInMemoryDatabase()).makeComicUseCase()
        XCTAssertNotNil(comicUseCase)
    }
    
}
