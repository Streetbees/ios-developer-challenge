//
//  DriveBase.swift
//  TestMarvel
//
//  Copyright © 2016 agit. All rights reserved.
//

import Foundation

public protocol DriveBase {
    func name() -> String
    
    func alreadyLoggedIn() -> Bool
    func doLogin(controller: UIViewController)
    func unlink()
    
    func saveFile(filename: String, content: NSData, onSuccess: () -> (), onError: (String) -> (), onProgress: (Double) -> ())
    func loadFile(filename: String, onSuccess: ()->(), onError: (String) -> ())
    func listFiles(onSuccess: (list: [String])->(), onError: (String) -> ())
    
    func fileFromDisk(filename: String) -> NSData?
    func fileToDisk(filename: String, content: NSData) -> Bool
}