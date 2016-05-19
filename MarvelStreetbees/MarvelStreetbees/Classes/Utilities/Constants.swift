//
//  Constants.swift
//  Ropo
//
//  Created by Pralea Danut on 21/12/15.
//  Copyright © 2015 parhelionsoftware. All rights reserved.
//

import Foundation
import UIKit

public class Constants {
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        static let Tmp = NSTemporaryDirectory()
    }
    
    class func Delegate() -> AppDelegate {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate
    }
    
    struct Settings {
        static let NUMBER_OF_EVENTS_TO_FETCH = 20
        static let kMarvelPublicKey = "61f38dd78195730322bce6c71249d8d1"
        static let kMarvelPrivateKey = "6152d1d8942d83475734dc90705fcee00a428372"
        static let kDropboxAppKey = "zjmigp99faek3z0"
        static let kDropboxAppSecret = "qv6p19v2k2r8hk1"
        static let kMarvelDropboxFolder = "/MarvelStreetbees"
        static let kMarvelDropboxSavedItemsFile = "my_items.plist"
    }
}