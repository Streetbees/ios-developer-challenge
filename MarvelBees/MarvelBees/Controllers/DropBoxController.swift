//
//  DropBoxController.swift
//  MarvelBees
//
//  Created by Andy on 26/05/2016.
//  Copyright © 2016 Pyrotechnic Apps Ltd. All rights reserved.
//

import Foundation
import SwiftyDropbox

enum DropboxError: ErrorType {
    case GeneralError(String)
}

class DropBoxController {
    

    func listFolderContents() {
        
        if let client = Dropbox.authorizedClient {
            
            client.files.listFolder(path: "").response { response, error in
                if let result = response {
                    log.debug("Folder contents:")
                    for entry in result.entries {
                        log.debug(entry.name)
                    }
                } else {
                    print(error!)
                }
            }
        }
    }
    
    
    func uploadCoverImage(comic: Comic, image: UIImage, progress: Float -> (), completion: DropboxError? -> ()) {
        guard let client = Dropbox.authorizedClient else {
            completion(DropboxError.GeneralError("Dropbox not linked"))
            return
        }
        
        let imageName = comic.dropboxFileName
        let fileData = UIImagePNGRepresentation(image)!
        
        client.files.upload(path: "\(imageName)", mode: .Overwrite, autorename: false, clientModified: .None, mute: false, body: fileData)
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                let value = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
                progress(value)
            }
            .response { response, error in
                if let e = error {
                    completion(DropboxError.GeneralError(e.description))
                } else {
                    completion(.None)
                }
        }
    }

    
    
    func downloadCoverImage(comic: Comic, completion: UIImage? -> ()) {
        guard let id = comic.id, let client = Dropbox.authorizedClient else {
            return
        }
        
        let imageName = comic.dropboxFileName
        
        func destination(temporaryURL: NSURL, response: NSHTTPURLResponse) -> NSURL {
            let path = generateImagePath(imageName)
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch {}
            
            return NSURL(fileURLWithPath: path)
        }
        
        client.files.download(path: "/\(imageName)", destination: destination).response { response, error in
            if let (_, url) = response {
                let data = NSData(contentsOfURL: url)!
                let image = UIImage(data: data)
                completion(image)
            } else {
                completion(.None)
            }
        }
    }
    
    private func generateImagePath(name: String) -> String {
        return (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent(name)
    }
    
}
