//
//  MarvelerTests.swift
//  MarvebleTests
//
//  Created by André Abou Chami Campana on 26/04/2016.
//  Copyright © 2016 Bell App Lab. All rights reserved.
//

import XCTest
@testable import Marveble


class MarvelerTests: XCTestCase, MarvelerDelegate
{
    typealias M = Comic
    
    var marveler: Marveler<M, MarvelerTests>!
    var expectation: XCTestExpectation!
    
    var hasStartedLoading: Bool = false {
        didSet {
            if oldValue == hasStartedLoading {
                XCTFail()
            }
        }
    }
    
    func willStartLoadingMarvelComics() {
        self.hasStartedLoading = true
    }
    
    func willFinishLoadingMarvelComics(errorMessage: String?) {
        self.hasStartedLoading = false
        if errorMessage != nil {
            XCTFail()
        }
    }
    
    var count = 1
    
    func didFinishLoadingMarvelComics<M>(comic: M) {
        count += 1
        if count == 100 {
            XCTAssertTrue(true, "We got 100 items")
            expectation.fulfill()
        }
        if count > 100 {
            XCTAssertTrue(false, "We got more than 100 items")
        }
    }
    
    override func setUp() {
        super.setUp()
        
        self.marveler = Marveler(delegate: self)
        self.expectation = expectationWithDescription("Waiting for Marvel's API")
    }
    
    func testAPI() {
        self.marveler.getComics(startingAt: 0)
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    
    @IBOutlet weak var spinningThing: UIActivityIndicatorView?
    
    func didChangeLoadingStatus(loading: Bool) {
        
    }
}
