//
//  AppDelegate.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    
    let navigationController = UINavigationController()
    
    let apiService = APIService()
    
    let homeViewController = HomeViewController(apiService: apiService)
    navigationController.viewControllers = [homeViewController]
    
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    
    return true
  }
}
