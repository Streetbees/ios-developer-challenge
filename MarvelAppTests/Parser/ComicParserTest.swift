//
//  ComicParserTest.swift
//  MarvelAppTests
//
//  Created by Rodrigo Cardoso on 26/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import XCTest
@testable import MarvelApp

class ComicParserTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_it_decodes_comic() {
        
        let comicParser = ComicParser(parser: JSONParser())
        XCTAssertNoThrow(try comicParser.decode(data: TestHelper().getComicsTestData()))
    }
    
    func test_it_fails_decode_comic() {
        
        let comicParser = ComicParser(parser: JSONParser())
        XCTAssertThrowsError(try comicParser.decode(data: TestHelper().getBadComicsTestData()))
    }
    
}
