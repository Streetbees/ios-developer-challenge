//
//  sbString-Ext.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


extension String
{    
    var md5: String?
    {
        guard let data = self.data(using: String.Encoding.utf8) else
        { return nil }
        
        let hash = data.withUnsafeBytes
        { (bytes: UnsafePointer<Data>) -> [UInt8] in
            
            var hash: [UInt8] = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes, CC_LONG(data.count), &hash)
            
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

