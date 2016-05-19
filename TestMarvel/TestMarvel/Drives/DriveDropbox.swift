//
//  DriveDropbox.swift
//  TestMarvel
//
//  Copyright © 2016 agit. All rights reserved.
//

import Foundation
import SwiftyDropbox

let DropboxAppKey = "sdnrfv9ezuoaoym";

class DriveDropbox : DriveBase {

    required init() {
        Dropbox.setupWithAppKey(DropboxAppKey)
    }
    
    func name() -> String {
        return "Dropbox"
    }
    
    func fileFromDisk(filename: String) -> NSData? {
        let url = urlFor(filename)
        if url.checkResourceIsReachableAndReturnError(nil) {
            if let data = NSData(contentsOfURL: url) {
                return data
            }
        }
        return nil
    }
    
    func fileToDisk(filename: String, content: NSData) -> Bool {
        //save file locally
        let url = urlFor(filename)
        if content.writeToURL(url, atomically: true) {
            return true
            
        } else {
            return false
        }
    }
        
    func listFiles(onSuccess: (list: [String]) -> (), onError: (String) -> ()) {
        if let client = Dropbox.authorizedClient {
            //list folder for files
            client.files.listFolder(path: "").response({ (result, err) in
                if let result = result {
                    var res: [String] = []
                    for entry in result.entries {
                        res.append(entry.name)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        onSuccess(list: res)
                    })
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        onError("Error listing files")
                    })
                }
            })
            
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                onError("Not linked")
            })
        }
    }
    
    func urlFor(filename: String) -> NSURL {
        let fileManager = NSFileManager.defaultManager()
        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let pathComponent = directoryURL.URLByAppendingPathComponent("customcomics")
        do {
            if !pathComponent.checkResourceIsReachableAndReturnError(nil) {
                try fileManager.createDirectoryAtURL(pathComponent, withIntermediateDirectories: true, attributes: nil)
            }
            
        } catch {
            //TODO log error
        }
        return pathComponent.URLByAppendingPathComponent(filename)
    }
    
    func loadFile(filename: String, onSuccess: () -> (), onError: (String) -> ()) {
        if let client = Dropbox.authorizedClient {
            client.files.download(path: "/\(filename)", destination: { (url, response) -> NSURL in
                return self.urlFor(filename)
                
            }).response({ (result, error) in
                if let (_, _) = result {
                    dispatch_async(dispatch_get_main_queue(), {
                        onSuccess()
                    })
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        onError("Error loading file")
                    })
                }
            })
            
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                onError("Error loading file")
            })
        }
    }
    
    func saveFile(filename: String, content: NSData, onSuccess: () -> (), onError: (String) -> (), onProgress: (Double) -> ()) {
        //upload file
        if let client = Dropbox.authorizedClient {
            client.files.upload(path: "/\(filename)", mode: Files.WriteMode.Overwrite, autorename: false, clientModified: NSDate(), mute: false, body: content).progress({ (current, actual, total) in
                dispatch_async(dispatch_get_main_queue(), {
                    onProgress(total<=0 ? 0.0 : (Double(actual)/Double(total)))
                })
                
            }).response({ (metadata, _) in
                if let _ = metadata {
                    dispatch_async(dispatch_get_main_queue(), {
                        onSuccess()
                    })
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        onError("Error uploading file")
                    })
                }
            })
            
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                onError("Error loading file")
            })
        }
    }
    
    func alreadyLoggedIn() -> Bool {
        return Dropbox.authorizedClient != nil
    }
    
    func doLogin(controller: UIViewController) {
        Dropbox.authorizeFromController(controller)
    }
 
    func unlink() {
        Dropbox.unlinkClient()
    }
}