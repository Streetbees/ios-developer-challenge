//
//  StreetbeesiOSChallengeTests.swift
//  StreetbeesiOSChallengeTests
//
//  Created by Joe Kletz on 27/10/2017.
//  Copyright © 2017 Joe Kletz. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import StreetbeesiOSChallenge

class StreetbeesiOSChallengeTests: XCTestCase {
    
    
    func testRequest() {

        var dataArray:[JSON]? = nil
        
        let getComics = GetComicsNetworkService()
        
        getComics.getParameters(offset: 0)
        getComics.request(urlString: "http://gateway.marvel.com/v1/public/comics") { (json) in
            
            dataArray = json["data"]["results"].array
            
            let comic = Comic(json: (dataArray?.first)!)
            
            XCTAssertNotNil(dataArray)
            XCTAssertNotNil(comic.description)
        }
    }
    
    func testJoinedString() {
        let detailVC = DetailViewController()
        let testSet = ["wordA","wordB"]

        XCTAssertEqual(detailVC.createCharacterList(characters:testSet), "wordA, wordB")
        
    }
    
}
