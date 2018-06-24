//
//  sbEnvironment.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


enum Environment: String
{
    case development
    case production
    
    static var current: Environment
    {
        #if DEVELOPMENT
        return .development
        #else
        return .production
        #endif
    }
    
    static var host: String
    {
        switch Environment.current
        {
        case .development:
            return "127.0.0.1"
        case .production:
            return "gateway.marvel.com"
        }
    }
}

