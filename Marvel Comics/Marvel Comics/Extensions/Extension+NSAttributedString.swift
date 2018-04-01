//
//  Extension+NSAttributedString.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation
import UIKit

protocol NSAttributedStringExtension {
  static func attributed(string: String, font: UIFont, color: UIColor) -> NSAttributedString
}

extension NSAttributedString : NSAttributedStringExtension {
  class func attributed(string: String, font: UIFont, color: UIColor) -> NSAttributedString {
    
    let attrs = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: color]
    return NSAttributedString(string: string, attributes: attrs)
  }
}
