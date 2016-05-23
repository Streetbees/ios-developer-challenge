//
//  StringExtension.swift
//  StreetBees-iOS-Marvel
//
//  Created by Javid Sheikh on 22/05/2016.
//  Copyright © 2016 Javid Sheikh. All rights reserved.
//

import Foundation

extension String {
    
    func digest(length:Int32, gen:(data: UnsafePointer<Void>, len: CC_LONG, md: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8>) -> String {
        var cStr = [UInt8](self.utf8)
        var result = [UInt8](count:Int(length), repeatedValue:0)
        gen(data: &cStr, len: CC_LONG(cStr.count), md: &result)
        
        let output = NSMutableString(capacity:Int(length))
        
        for r in result {
            output.appendFormat("%02x", r)
        }
        
        return String(output)
    }
    
}
