//
//  RMComicUseCaseTests.swift
//  MarvelAppTests
//
//  Created by Rodrigo Cardoso on 28/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import XCTest
@testable import MarvelApp

class RMComicUseCaseTests: XCTestCase {
    
    let comicUseCase = RMUseCaseProvider(configuration: RealmTestsSetup.init().setInMemoryDatabase()).makeComicUseCase()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        RealmTestsSetup().clearDatabase()
        super.tearDown()
    }
    
    private func populateTestData() {
        
        let comicParser = ComicParser(parser: JSONParser())
        let comicsToSave: [Comic] = try! comicParser.decode(data: TestHelper().getComicsTestData()).data.results
        
        do {
            try comicUseCase.save(comics: comicsToSave)
        } catch {
            XCTFail("Fail to save Comics")
        }
    }
    
    func test_it_load_comics() {
        
        populateTestData()
        
        let comics = comicUseCase.fetchComics()
        XCTAssertNotNil(comics)
        XCTAssertEqual(comics.count, 5)
        
    }

    func test_it_load_comics_ordered() {
        
        populateTestData()
        
        let comics = comicUseCase.fetchComics(sortDescriptors: [NSSortDescriptor(keyPath: \RMComic.title, ascending: true)])
        XCTAssertNotNil(comics)
        XCTAssertEqual(comics.count, 5)
        XCTAssertEqual(comics.first?.title, "Cap Transport (2005) #4")
        XCTAssertEqual(comics[1].title, "Civil War II (2016) #6 (Gi Connecting Variant H)")
        XCTAssertEqual(comics[2].title, "The Punisher (2016) #5 (Cosplay Variant)")
        XCTAssertEqual(comics[3].title, "Ultimate X-Men (Spanish Language Edition) (2000) #9")
        XCTAssertEqual(comics[4].title, "X-Men (2010)")
    }
    
    func test_it_fails_to_load_comic() {
        
        populateTestData()
        
        let comics = comicUseCase.fetchComic(withId: 0)
        XCTAssertNil(comics)
    }
    
    func test_it_load_comic_with_id() {
        
        populateTestData()
        
        let comics = comicUseCase.fetchComic(withId: 38041)
        XCTAssertNotNil(comics)
    }

    func test_it_load_comic_with_title() {
        
        populateTestData()
        
        let comics = comicUseCase.fetchComic(withTitle: "X-Men")
        XCTAssertNotNil(comics)
        XCTAssertEqual(comics.count, 2)
    }
    
    func test_it_saves_comics() {
        
        let comicParser = ComicParser(parser: JSONParser())
        let comicsToSave: [Comic] = try! comicParser.decode(data: TestHelper().getComicsTestData()).data.results
    
        XCTAssertNoThrow(try comicUseCase.save(comics: comicsToSave))
    }
}
