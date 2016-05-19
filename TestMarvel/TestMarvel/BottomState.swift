//
//  BottomState.swift
//  TestMarvel
//
//  Copyright © 2016 agit. All rights reserved.
//

import Foundation

enum BottomState {
    case Retrieving
    case NeedsLogin
    case AlreadyLoggedIn
    case Downloading(Double)
}