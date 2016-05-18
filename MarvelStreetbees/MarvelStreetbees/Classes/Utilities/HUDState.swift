//
//  HUDState.swift
//  SportXast
//
//  Created by Danut Pralea on 14/01/16.
//  Copyright © 2016 SportXast. All rights reserved.
//

import Foundation

public enum HUDState {
    case Started
    case Success
    case SuccessWithMessage(String)
    case ErrorWithMessage(String)
}