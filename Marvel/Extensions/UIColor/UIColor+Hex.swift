//
//  UIColor+Hex.swift
//  Marvel
//
//  Created by Gabriel Massana on 18/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

extension UIColor {
    
    /**
     Creates UIColor object based on given hexadecimal color value (rrggbb).
     
     - parameter hex: String with the hex information.
     
     - returns: A UIColor from the given String.
     */
    class func colorWithHex(hex: String) -> UIColor? {
        
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        
        var color:UIColor? = nil
        
        let noHash = hex.stringByReplacingOccurrencesOfString("#", withString: "")
        
        let start = noHash.startIndex
        let hexColor = noHash.substringFromIndex(start)
        
        if hexColor.characters.count == 6 {
            
            let scanner = NSScanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexLongLong(&hexNumber) {
                
                red = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                blue = CGFloat(hexNumber & 0x0000ff) / 255
                
                color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            }
        }
        
        return color
    }
}
