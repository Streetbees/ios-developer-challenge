//
//  NetworkServiceTests.swift
//  MarvelAppTests
//
//  Created by Rodrigo Cardoso on 26/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import XCTest
@testable import MarvelApp

class NetworkServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_api_request_fails() {
        
        let mock = MockFailure(requestError: NetworkError.connectionError, responseObject: nil)
        
        let marvelService = MarvelService(api: mock)
        
        let expectation = XCTestExpectation(description: "Request Fail")
        
        marvelService.getComics(offset: 0) { data, error in
            XCTAssertNil(data)
            XCTAssertEqual(error as! NetworkError, NetworkError.connectionError)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_api_request_success() {
        
        let mock = MockSuccess(responseObject: TestHelper().getComicsTestData())
        
        let marvelService = MarvelService(api: mock)
        
        let expectation = XCTestExpectation(description: "Request Success")
        
        marvelService.getComics(offset: 0) { data, error in
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
}
