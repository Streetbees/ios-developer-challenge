//
//  ComicFeedTests.swift
//  Marvel
//
//  Created by GabrielMassana on 19/05/2016.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import XCTest

@testable import Marvel

import CoreDataFullStack

class ComicFeedTests: XCTestCase , CDFCoreDataManagerDelegate {
    
    //MARK: - Accessors
    
    var parser: ComicsFeedParser?
    
    var comicsJSON: NSArray?
    var comicJSON: NSDictionary?
    var feedJSON: NSDictionary?
    var dataJSON: NSDictionary?
    
    var comicID: NSNumber?
    var title: String?
    var comicDescription: String?
    var thumbnailPath: String?
    var thumbnailExtension: String?
    var dateType: String?
    var date: String?
    
    var totalComics: NSNumber?

    
    //MARK: - CDFCoreDataManagerDelegate
    
    internal func coreDataModelName() -> String! {
        
        return "Marvel"
    }
    
    // MARK: - TestSuiteLifecycle
    
    override func setUp() {
        
        super.setUp()
        
        CDFCoreDataManager.sharedInstance().delegate = self
        
        parser = ComicsFeedParser(managedObjectContext: CDFCoreDataManager.sharedInstance().managedObjectContext)
        
        comicID = NSNumber(int: 123456)
        title = "Captain Marvel"
        comicDescription = "Some description"
        thumbnailPath = "http://i.annihil.us/u/prod/marvel/i/mg/5/a0/4c0030bc4629e"
        thumbnailExtension = "jpg"
        dateType = "onsaleDate"
        date = "2015-12-31T19:00:00-0500"
        
        totalComics = NSNumber(int: 1234)
            
        comicJSON = [
            "id": comicID!,
            "title": title!,
            "description": comicDescription!,
            "thumbnail": [
                "path": thumbnailPath!,
                "extension": thumbnailExtension!
            ],
            "dates": [
                [
                    "type": dateType!,
                    "date": date!
                ],
                [
                    "type": "otherType",
                    "date": "2014-12-31T19:00:00-0500"
                ]
            ]
        ]
        
        comicsJSON = [
            comicJSON!,
            [
                "id": 789456,
                "title": "other title",
                "description": "other one",
                "thumbnail": [
                    "path": thumbnailPath!,
                    "extension": thumbnailExtension!
                ],
                "dates": [
                    [
                        "type": dateType!,
                        "date": date!
                    ],
                    [
                        "type": "otherType",
                        "date": "2014-12-31T19:00:00-0500"
                    ]
                ]
            ]
        ]
        
        dataJSON = [
            "total": totalComics!,
            "results": comicsJSON!
        ]
        
        
        feedJSON = [
            "data": dataJSON!
        ]
    }
    
    override func tearDown() {
        
        parser = nil
        
        comicsJSON = nil
        comicJSON = nil
        feedJSON = nil
        dataJSON = nil
        
        comicID = nil
        title = nil
        comicDescription = nil
        thumbnailPath = nil
        thumbnailExtension = nil
        dateType = nil
        date = nil
        totalComics = nil
        
        super.tearDown()
    }
    
    // MARK: - Feed
    
    func test_parseFeed_newComicObjectReturned() {
        
        let feed = parser?.parseFeed(feedJSON!)
        
        XCTAssertNotNil(feed, "A valid Comic Feed object wasn't created");
    }
    
    func test_parseFeed_total() {
        
        let feed = parser?.parseFeed(feedJSON!)
        
        XCTAssertTrue(feed!.totalComics == totalComics, String(format:"totalComics property was not set properly. Was set to: %@ rather than: %@", feed!.totalComics!, totalComics!));
    }
}
