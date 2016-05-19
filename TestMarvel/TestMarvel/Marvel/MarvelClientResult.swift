//
//  MarvelClientResult.swift
//  TestMarvel
//
//  Copyright © 2016 agit. All rights reserved.
//

import Foundation

enum MarvelClientResult {
    case Success(ComicDataWrapper)
    case Error(String)
}