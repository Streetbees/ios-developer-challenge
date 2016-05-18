//
//  MenuViewController.swift
//  SportXast
//
//  Created by Danut Pralea on 10/01/16.
//  Copyright © 2016 SportXast. All rights reserved.
//

import Foundation

public enum NetworkError: ErrorType, CustomStringConvertible {
    
    /// Unknown or not supported error.
    case Unknown
    /// Custom message inserted
    case Custom(message: String)
    /// Cannot reach the server.
    case ServerConnectionProblems(message: String)
    /// Incorrect data returned from the server.
    case IncorrectDataReturned
    ///
    case InternalServerError(message: String)
    ///
    case NoValidFacebookSession
    ///
    case NotEnoughPermissions
    ///
    case InvalidDataForParsing
    
    public var description: String {
        let text: String
        switch self {
        case Unknown:
            text = "Unknown"
        case .Custom(let message):
            text = "\(message)"
        case ServerConnectionProblems(let message):
            text = "ServerConnectionProblems: \(message)"
        case IncorrectDataReturned:
            text = "IncorrectDataReturned"
        case InternalServerError(let message):
            text = "InternalServerError: \(message)"
        case .NoValidFacebookSession:
            text = "FacebookSessionNotValid"
        case NotEnoughPermissions:
            return "Not Enough permissions"
        case InvalidDataForParsing:
            return "Data for Parsing is invalid!"
        }
        
        
        return text
    }
    
    
}
