//
//  HUDState.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 18/05/16.
//  Copyright © 2016 MarvelStreetbees. All rights reserved.
//

import Foundation

public enum HUDState {
    case Started
    case Success
    case SuccessWithMessage(String)
    case ErrorWithMessage(String)
}