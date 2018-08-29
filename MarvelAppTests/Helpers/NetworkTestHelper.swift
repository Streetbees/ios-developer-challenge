//
//  NetworkTestHelper.swift
//  MarvelAppTests
//
//  Created by Rodrigo Cardoso on 26/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation
import Alamofire
@testable import MarvelApp

enum NetworkError: Error {
    case connectionError
}

protocol BaseMockAPI: MarvelAPI {
    var methodWasCalled: Bool { get set }
    var responseObject: Data? { get set }
}

protocol ErrorMockAPI: BaseMockAPI {
    var requestError: Error { get set }
}

class MockSuccess: BaseMockAPI {

    var methodWasCalled: Bool = false
    var responseObject: Data?
    
    init(responseObject: Data) {
        self.responseObject = responseObject
    }
    
    func getComics(request: URLRequestConvertible, completionHandler: @escaping NetworkRequestCompletionHandler) {
        methodWasCalled = true
        
        completionHandler(self.responseObject, nil)
    }
}

class MockFailure: ErrorMockAPI {
    
    var methodWasCalled: Bool = false
    
    var responseObject: Data?
    var requestError: Error
    
    init(requestError: Error, responseObject: Data?) {
        self.requestError = requestError
        self.responseObject = responseObject
    }
    
    func getComics(request: URLRequestConvertible, completionHandler: @escaping NetworkRequestCompletionHandler) {
        methodWasCalled = true
        
        guard let responseObject = self.responseObject else {
            completionHandler(nil, requestError)
            return
        }
        
        completionHandler(responseObject, requestError)
    }
}
