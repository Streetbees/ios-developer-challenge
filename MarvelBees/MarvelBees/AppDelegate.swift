//
//  AppDelegate.swift
//  MarvelBees
//
//  Created by Andy on 20/05/2016.
//  Copyright © 2016 Pyrotechnic Apps Ltd. All rights reserved.
//

import UIKit
import XCGLogger
import SwiftyDropbox

// Configure logging
let log: XCGLogger = {
    let log = XCGLogger.defaultInstance()
    log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true)
    log.xcodeColorsEnabled = true
    return log
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Set this so we get nice white text in status bar to match
        UINavigationBar.appearance().barStyle = .Black
        
        // Dropbox integration
        Dropbox.setupWithAppKey(Constants.DropBoxAppKey)
    
        return true
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        // Dropbox integration
        if let authResult = Dropbox.handleRedirectURL(url) {
            switch authResult {
            case .Success(let token):
                log.debug("Success: User logged into Dropbox.")
            case .Error(let error, let description):
                log.debug("Error: \(description)")
            }
        }
        
        return false
    }

    
}

