//
//  FileLoadable.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 25/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation

public protocol FileLoadable {
    static func load(file: String, type: String, fromBundle bundle: Bundle) -> String?
}

public extension FileLoadable {
    static func load(file: String, type: String, fromBundle bundle: Bundle = Bundle.main) -> String? {
        guard let path = bundle.path(forResource: file, ofType: type) else {
            return nil
        }
        return try? String(contentsOfFile: path, encoding: String.Encoding.utf8)
    }
}
