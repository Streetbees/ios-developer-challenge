//
//  RMComicImageTests.swift
//  MarvelAppTests
//
//  Created by Rodrigo Cardoso on 26/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import XCTest
@testable import MarvelApp

class RMComicImageTests: XCTestCase {
    
    var comicImage: ComicImage!
    var rmComicImage: RMComicImage!
    
    override func setUp() {
        super.setUp()
        
        comicImage = ComicImage(path: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available", imageExtension: "jpg")
        rmComicImage = comicImage.asRealm()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_it_successfully_creates_rmObject() {
        XCTAssertEqual(comicImage.path, rmComicImage.path)
        XCTAssertEqual(comicImage.imageExtension, rmComicImage.imageExtension)
    }
}
