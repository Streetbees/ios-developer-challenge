//
//  AppDelegate.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 18/05/16.
//  Copyright © 2016 MarvelStreetbees. All rights reserved.
//

import UIKit
import CoreData
import SwiftyDropbox
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    
    private let disposeBag = DisposeBag()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Dropbox.setupWithAppKey(Constants.Settings.kDropboxAppKey)
        
        Dropbox.authorizedClient?
            .rx_createFolder(path: Constants.Settings.kMarvelDropboxFolder)
            .subscribe()
            .addDisposableTo(disposeBag)
        
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        if let authResult = Dropbox.handleRedirectURL(url) {
            switch authResult {
            case .Success(let token):
                print("Success! User is logged into Dropbox with token: \(token)")
                Dropbox.authorizedClient?
                    .rx_createFolder(path: Constants.Settings.kMarvelDropboxFolder)
                    .subscribe()
                    .addDisposableTo(disposeBag)
            case .Error(let error, let description):
                print("Error \(error): \(description)")
            }
        }
        
        return false
    }
}



