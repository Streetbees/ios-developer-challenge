//
//  AppDelegate.swift
//  Marveble
//
//  Created by André Abou Chami Campana on 25/04/2016.
//  Copyright © 2016 Bell App Lab. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Appearance.customise()
        
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        handleOpenURLForDropboxer(url, options: options)
        return false
    }
    
    
}

