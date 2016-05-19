//
//  AppDelegate.swift
//  Marvel
//
//  Created by Gabriel Massana on 17/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

import CoreDataFullStack
import CoreOperation

let NetworkDataOperationQueueTypeIdentifier: String = "NetworkDataOperationQueueTypeIdentifier"
let LocalDataOperationQueueTypeIdentifier: String = "LocalDataOperationQueueTypeIdentifier"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: - Accessors
    
    var window: UIWindow? = {
        
        DropboxService.sharedInstance
        
        /*-------------------*/

        let window: UIWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.whiteColor()
        
        return window
    }()

    /**
     The Navigation Controller working as rootViewController.
     */
    var rootNavigationController: RootNavigationController = RootNavigationController()
    
    //MARK: - UIApplicationDelegate

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        CDFCoreDataManager.sharedInstance().delegate = self
        
        /*-------------------*/
        
        registerOperationQueues()
        
        /*-------------------*/
        
        window!.rootViewController = rootNavigationController
        window!.makeKeyAndVisible()
        
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
    
    func application(application: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {

        if DBSession.sharedSession().handleOpenURL(url) {
            
            if DBSession.sharedSession().isLinked() {
                
                print("Dropbox Linked")
            }
            
            return true
        }
        
        return false
    }
    
    //MARK: - OperationQueues
    
    /**
     Registers the operations queues in the app.
     */
    func registerOperationQueues() {
        
        let networkDataOperationQueue:NSOperationQueue = NSOperationQueue()
        networkDataOperationQueue.qualityOfService = .Background
        networkDataOperationQueue.maxConcurrentOperationCount = 1
        COMOperationQueueManager.sharedInstance().registerOperationQueue(networkDataOperationQueue, operationQueueIdentifier: NetworkDataOperationQueueTypeIdentifier)
        
        let localDataOperationQueue:NSOperationQueue = NSOperationQueue()
        localDataOperationQueue.qualityOfService = .Background
        localDataOperationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount
        COMOperationQueueManager.sharedInstance().registerOperationQueue(localDataOperationQueue, operationQueueIdentifier: LocalDataOperationQueueTypeIdentifier)
    }
}

//MARK: - CDFCoreDataManagerDelegate

extension AppDelegate : CDFCoreDataManagerDelegate {
    
    internal func coreDataModelName() -> String! {
        
        return "Marvel"
    }
}

