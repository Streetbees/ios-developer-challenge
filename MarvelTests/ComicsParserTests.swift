//
//  ComicsParserTests.swift
//  MarvelTests
//
//  Created by GabrielMassana on 19/05/2016.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import XCTest

@testable import Marvel

import CoreDataFullStack

class ComicsParserTests: XCTestCase, CDFCoreDataManagerDelegate {
    
    //MARK: - Accessors

    var parser: ComicsParser?
    
    var comicsJSON: NSArray?
    var comicJSON: NSDictionary?
    
    var comicID: NSNumber?
    var title: String?
    var comicDescription: String?
    var thumbnailPath: String?
    var thumbnailExtension: String?
    var dateType: String?
    var date: String?
    
    //MARK: - CDFCoreDataManagerDelegate
    
    internal func coreDataModelName() -> String! {
        
        return "Marvel"
    }
    
    // MARK: - TestSuiteLifecycle

    override func setUp() {
        
        super.setUp()
        
        CDFCoreDataManager.sharedInstance().delegate = self
        
        parser = ComicsParser(managedObjectContext: CDFCoreDataManager.sharedInstance().managedObjectContext)
        
        comicID = NSNumber(int: 123456)
        title = "Captain Marvel"
        comicDescription = "Some description"
        thumbnailPath = "http://i.annihil.us/u/prod/marvel/i/mg/5/a0/4c0030bc4629e"
        thumbnailExtension = "jpg"
        dateType = "onsaleDate"
        date = "2015-12-31T19:00:00-0500"
        
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
    }
    
    override func tearDown() {

        parser = nil

        comicsJSON = nil
        comicJSON = nil

        comicID = nil
        title = nil
        comicDescription = nil
        thumbnailPath = nil
        thumbnailExtension = nil
        dateType = nil
        date = nil
        
        super.tearDown()
    }
    
    // MARK: - ComicParser

    func test_parseComic_newComicObjectReturned() {
        
        let comic = parser?.parseComic(comicJSON!)
        
        XCTAssertNotNil(comic, "A valid Comic object wasn't created");
    }
    
    func test_parseComic_comicID() {
        
        let comic = parser?.parseComic(comicJSON!)
        
        XCTAssertTrue(comic!.comicID! == comicID!.stringValue, String(format:"ComicID property was not set properly. Was set to: %@ rather than: %@", comic!.comicID!, comicID!.stringValue));
    }
    
    func test_parseComic_title() {
        
        let comic = parser?.parseComic(comicJSON!)
        
        XCTAssertTrue(comic!.title! == title!, String(format:"name property was not set properly. Was set to: %@ rather than: %@", comic!.title!, title!));
    }

    func test_parseComic_comicDescription() {
        
        let comic = parser?.parseComic(comicJSON!)
        
        XCTAssertTrue(comic!.comicDescription! == comicDescription!, String(format:"ComicDescription property was not set properly. Was set to: %@ rather than: %@", comic!.comicDescription!, comicDescription!));
    }
    
    func test_parseComic_thumbnailPath() {
        
        let comic = parser?.parseComic(comicJSON!)
        
        XCTAssertTrue(comic!.thumbnailPath == thumbnailPath, String(format:"thumbnailPath property was not set properly. Was set to: %@ rather than: %@", comic!.thumbnailPath!, thumbnailPath!));
    }
    
    func test_parseComic_thumbnailExtension() {
        
        let comic = parser?.parseComic(comicJSON!)
        
        XCTAssertTrue(comic!.thumbnailExtension == thumbnailExtension, String(format:"thumbnailExtension property was not set properly. Was set to: %@ rather than: %@", comic!.thumbnailExtension!, thumbnailExtension!));
    }
    
    func test_parseComic_onSaleDate() {
        
        let comic = parser?.parseComic(comicJSON!)
        
        let dateFormatter: NSDateFormatter = NSDateFormatter.serverDateFormatter()
        
        let dateFormated = dateFormatter.dateFromString(date!)
        
        XCTAssertTrue(comic!.onSaleDate == dateFormated, String(format:"onsaleDate property was not set properly. Was set to: %@ rather than: %@", comic!.onSaleDate!, dateFormated!));
    }
    
    // MARK: - ComicsParser

    func test_parseComics_newComicsArrayReturned() {
        
        let comics = parser?.parseComics(comicsJSON!)
        
        XCTAssertNotNil(comics, "A valid Comics Array object wasn't created");
    }
    
    func test_parseComics_count() {
        
        let comics = parser?.parseComics(comicsJSON!)
        
        let arrayCount = NSNumber(integer: comics!.count)
        let jsonCount = NSNumber(integer: comicsJSON!.count)
        
        XCTAssertTrue(arrayCount == jsonCount, String(format:"Parsed count is wrong. Should be %@ rather than: %@", arrayCount , jsonCount));
    }
    
    func test_parseComics_uniqueObjects() {
        
        let comics = parser?.parseComics(comicsJSON!)
        
        let firstObject = comics?.firstObject as! Marvel.Comic
        let lastObject = comics?.lastObject as! Marvel.Comic
        
        XCTAssertNotEqual(firstObject , lastObject, String(format:"Parsed comics without different objects: %@ and %@", firstObject , lastObject));
    }
    
    func test_parseComics_orderFirstObjects() {
        
        let comics = parser?.parseComics(comicsJSON!)
        
        let firstObjectParsed = comics?.firstObject as! Marvel.Comic
        let firstObject = comicsJSON!.firstObject as! NSDictionary
        
        XCTAssertEqual(firstObjectParsed.comicID, (firstObject["id"] as! NSNumber).stringValue, String(format:"Should have the same ID: %@", firstObjectParsed.comicID!));
    }
    
    func test_parseComics_orderLastObjects() {
        
        let comics = parser?.parseComics(comicsJSON!)
        
        let lastObjectParsed = comics?.lastObject as! Marvel.Comic
        let lastObject = comicsJSON!.lastObject as! NSDictionary
        
        XCTAssertEqual(lastObjectParsed.comicID, (lastObject["id"] as! NSNumber).stringValue, String(format:"Should have the same ID: %@", lastObjectParsed.comicID!));
    }
}




