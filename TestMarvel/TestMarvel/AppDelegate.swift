//
//  AppDelegate.swift
//  TestMarvel
//
//  Copyright © 2016 agit. All rights reserved.
//

import UIKit
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        let viewControllers = window!.rootViewController!.childViewControllers
        for viewController in viewControllers {
            if viewController.isKindOfClass(ComicsViewController) {
                (viewController as! ComicsViewController).driveAppDelegateURL(url)
            }
        }
        
        return false
    }
}

