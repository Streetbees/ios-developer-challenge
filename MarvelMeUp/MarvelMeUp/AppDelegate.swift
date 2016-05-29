//
//  AppDelegate.swift
//  MarvelMeUp
//
//  Created by Dimitar Chakarov on 5/23/16.
//  Copyright © 2016 JI Apps Ltd. All rights reserved.
//

import UIKit
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Dropbox.setupWithAppKey("fzrzdtcstsp6q75")
        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if let authResult = Dropbox.handleRedirectURL(url) {
            switch authResult {
            case .Success(let token):
                print("Success! User is logged into Dropbox with token: \(token)")
            case .Error(let error, let description):
                print("Error \(error): \(description)")
            }
        }
        
        return false
    }

}

