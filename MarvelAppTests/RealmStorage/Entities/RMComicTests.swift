//
//  RMComicTests.swift
//  MarvelAppTests
//
//  Created by Rodrigo Cardoso on 26/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import XCTest
@testable import MarvelApp

class RMComicTests: XCTestCase {
    
    var comic: Comic!
    var rmComic: RMComic!
    
    override func setUp() {
        super.setUp()

        let comicParser = ComicParser(parser: JSONParser())
        
        comic = try! comicParser.decode(data: TestHelper().getComicsTestData()).data.results.first!
        rmComic = comic.asRealm()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_it_successfully_creates_rmObject() {
        XCTAssertEqual(comic.id, rmComic.id)
        XCTAssertEqual(comic.digitalId, rmComic.digitalId)
        XCTAssertEqual(comic.title, rmComic.title)
        XCTAssertEqual(comic.issueNumber, rmComic.issueNumber)
        XCTAssertEqual(comic.variantDescription, rmComic.variantDescription)
        XCTAssertEqual(comic.description, rmComic.comicDescription)
        XCTAssertEqual(comic.modified, rmComic.modified)
        XCTAssertEqual(comic.format, rmComic.format)
        XCTAssertEqual(comic.pageCount, rmComic.pageCount)
        XCTAssertEqual(comic.resourceURI, rmComic.resourceURI)
        XCTAssertEqual(comic.thumbnail.path, rmComic.thumbnail?.path)
        XCTAssertEqual(comic.thumbnail.imageExtension, rmComic.thumbnail?.imageExtension)
    }
    
}
