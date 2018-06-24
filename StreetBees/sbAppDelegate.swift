//
//  AppDelegate.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    // MARK: - Property(s)
    
    var window: UIWindow?


    // MARK: - UIApplicationDelegate Protocol
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = ComicsController(nibName: nil, bundle: nil)
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

