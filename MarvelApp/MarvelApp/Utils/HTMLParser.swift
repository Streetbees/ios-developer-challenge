//
//  HTMLParser.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            
        } catch {
            return NSAttributedString()
        }
    }
    var htmlString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
