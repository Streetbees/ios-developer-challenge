//
//  TestHelpers.swift
//  MarvelAppTests
//
//  Created by Rodrigo Cardoso on 25/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation
@testable import MarvelApp

struct ComicsStub: FileLoadable {}

class TestHelper {
    
    func getComicsTestData() -> Data {
        let comicsJSON = ComicsStub.load(file: "comics", type: "json", fromBundle: Bundle(for: type(of: self)))!
        
        return comicsJSON.data(using: .utf8)!
    }
    
    func getBadComicsTestData() -> Data {
        let comicsJSON = ComicsStub.load(file: "invalidComics", type: "json", fromBundle: Bundle(for: type(of: self)))!
        
        return comicsJSON.data(using: .utf8)!
    }
}
