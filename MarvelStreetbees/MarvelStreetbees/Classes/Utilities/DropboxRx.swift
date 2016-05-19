//
//  DropboxRx.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 19/05/16.
//  Copyright © 2016 MarvelStreetbees. All rights reserved.
//

import Foundation
import SwiftyDropbox
import RxSwift



extension DropboxClient {
    
    func rx_list(path path: String) -> Observable<Array<Files.Metadata>> {
        
        return Observable.create { observer in
            
            // List folder
            self.files.listFolder(path: path).response { response, error in
                if let error = error {
                    
                    if case let .HTTPError(code, _, _) = error where code == 401 {
                        observer.on(.Error(NetworkError.DropBoxNotAuthorized))
                    } else {
                        observer.on(.Error(NetworkError.Custom(message: error.description)))
                    }
                    
                } else {
                    
                    if let response = response {
                        observer.on(.Next(response.entries))
                        observer.on(.Completed)
                    } else {
                        observer.onError(NetworkError.Custom(message: "empty response"))
                    }
                }
            }
            
            return NopDisposable.instance
        }
    }
    
    func rx_upload(path path: String, body: NSData) -> Observable<Bool> {
        
        return Observable.create { observer in
            
            // upload
            self.files
                .upload(path: path, body: body)
                .response { response, error in
                    
                    if let error = error {
                        observer.on(.Error(NetworkError.Custom(message: error.description)))
                        
                    } else {
                        
                        if let _ = response {
                            observer.on(.Next(true))
                            observer.on(.Completed)
                        } else {
                            observer.onError(NetworkError.Custom(message: "empty response upload"))
                        }
                        
                    }
            }
            
            return NopDisposable.instance
        }
    }
    
    func rx_download(path path: String) -> Observable<NSData> {
        
        return Observable.create { observer in
            
            let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                let fileManager = NSFileManager.defaultManager()
                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                // generate a unique name for this file in case we've seen it before
                return directoryURL.URLByAppendingPathComponent(Constants.Settings.kMarvelDropboxSavedItemsFile)
            }
            
            
            self
                .files
                .download(path: path, destination: destination)
                .response { response, error in
                    
                    if let error = error {
                        observer.on(.Error(NetworkError.Custom(message: error.description)))
                    } else {
                        
                        if let (_, url) = response, let data = NSData(contentsOfURL: url) {
                            observer.on(.Next(data))
                            observer.on(.Completed)
                        }
                        else {
                            observer.on(.Error(NetworkError.Custom(message: "download error on parse")))
                        }
                    }
                    
            }
            
            
            return NopDisposable.instance
        }
    }
    
    func rx_fileExists(fileName: String, atPath: String) -> Observable<Bool> {
        
        return Observable.create { observer in
            
            self.files
                .search(path: atPath, query: fileName)
                .response({ searchResult, error in
                    
                    if let error = error {
                        observer.on(.Error(NetworkError.Custom(message: error.description)))
                    } else {
                        
                        if let searchResult = searchResult {
                            
                            print("----- searchResult: \(searchResult.description)")
                            if searchResult.matches.count > 0 {
                                observer.on(.Next(true))
                            } else {
                                observer.on(.Next(false))
                            }
                            observer.on(.Completed)
                            
                        } else {
                            observer.onError(NetworkError.Custom(message: "empty response"))
                        }
                    }
                    
                })
            
            return NopDisposable.instance
        }
        
    }
    
    func rx_createFolder(path path: String) -> Observable<Bool> {
        
        return Observable.create { observer in
            
            // upload
            self.files
                .createFolder(path: path)
                .response { response, error in
                    
                    if let error = error {
                        observer.on(.Error(NetworkError.Custom(message: error.description)))
                        
                    } else {
                        
                        if let _ = response {
                            observer.on(.Next(true))
                            observer.on(.Completed)
                        } else {
                            observer.onError(NetworkError.Custom(message: "empty response upload"))
                        }
                        
                    }
            }
            
            return NopDisposable.instance
        }
    }
    
}

