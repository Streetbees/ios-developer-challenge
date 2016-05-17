//
//  NSDateFormatter+ServerResponse.swift
//  Marvel
//
//  Created by Gabriel Massana on 17/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import Foundation

let DateFormatterKey: String = "DateFormatterKey"

extension NSDateFormatter {
    
    //MARK: - ServerResponse
    
    /**
    Date Formatter to parse date strings returned from Marvel JSON.
    
    - Returns: NSDateFormatter instance.
    */
    class func serverDateFormatter() -> NSDateFormatter! {
        
        if (NSThread.currentThread().threadDictionary["DateFormatterKey"] == nil) {
            
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxx"
            
            NSThread.currentThread().threadDictionary["DateFormatterKey"] = dateFormatter
        }
        
        return NSThread.currentThread().threadDictionary["DateFormatterKey"] as! NSDateFormatter
    }
}