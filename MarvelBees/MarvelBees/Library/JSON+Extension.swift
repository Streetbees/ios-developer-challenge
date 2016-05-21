//
//  JSON+Extension.swift
//  MarvelBees
//
//  Created by Andy on 21/05/2016.
//  Copyright © 2016 Pyrotechnic Apps Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    
    public var date: NSDate? {
        get {
            switch self.type {
            case .String:
                return DateFormatter.jsonDateFormatter.dateFromString(self.object as! String)
            default:
                return nil
            }
        }
    }
    
    public var dateTime: NSDate? {
        get {
            switch self.type {
            case .String:
                return DateFormatter.jsonDateTimeFormatter.dateFromString(self.object as! String)
            default:
                return nil
            }
        }
    }
    
}


class DateFormatter {
    
    private static var internalJsonDateFormatter: NSDateFormatter?
    private static var internalJsonDateTimeFormatter: NSDateFormatter?
    
    static var jsonDateFormatter: NSDateFormatter {
        if (internalJsonDateFormatter == nil) {
            internalJsonDateFormatter = NSDateFormatter()
            internalJsonDateFormatter!.dateFormat = "yyyy-MM-dd" // TODO, format
        }
        return internalJsonDateFormatter!
    }
    
    static var jsonDateTimeFormatter: NSDateFormatter {
        if (internalJsonDateTimeFormatter == nil) {
            internalJsonDateTimeFormatter = NSDateFormatter()
            internalJsonDateTimeFormatter!.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        }
        return internalJsonDateTimeFormatter!
    }
    
}

