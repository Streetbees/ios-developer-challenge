//
//  ComicsTests.swift
//  MarvelAppTests
//
//  Created by Rodrigo Cardoso on 25/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import XCTest
@testable import MarvelApp

class ComicsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_it_initiate_comic() {
        
        let comicParser = ComicParser(parser: JSONParser())
        let comic: PayloadWrapper<Comic> = try! comicParser.decode(data: TestHelper().getComicsTestData())
        
        XCTAssertNotNil(comic)
        XCTAssertNotNil(comic.data)
        XCTAssertNotNil(comic.data.results)
        XCTAssertEqual(comic.data.results.first?.id, 38041)
        XCTAssertEqual(comic.data.results.first?.digitalId, 0)
        XCTAssertEqual(comic.data.results.first?.title, "X-Men (2010)")
        XCTAssertEqual(comic.data.results.first?.images.count, 0)
        XCTAssertEqual(comic.data.results.first?.thumbnail.path, "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available")
    }
    
}
