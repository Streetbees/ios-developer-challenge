//
//  Dropboxer.swift
//  Marveble
//
//  Created by André Abou Chami Campana on 26/04/2016.
//  Copyright © 2016 Bell App Lab. All rights reserved.
//

import SwiftyDropbox
import BLLogger


//MARK: - Dropboxer Delegate
/*
 This is how objects get responses from the Dropboxer
 */
public protocol DropboxerDelegate: AnyObject
{
    associatedtype DC
    func didListDropboxFolder(success: Bool) //Called when we finish listing the contents of our folder on Dropbox; returns nil if there was an error and an empty array if the folder is empty
    func didDownloadFileFromDropbox<DC>(withComic comic: DC, andURL url: NSURL?) //Called when we finish downloading files from Dropbox; returns nil if there was an error
    func didUploadFileToDropbox(withMetadata metadata: SwiftyDropbox.Files.FileMetadata?) //Called when we finish uploading files to Dropbox; returns nil if there was an error
}


//MARK: - Dropboxer, the watchdog
/*
 This is the controller that interacts with Dropbox's API
 This controller checks if the user has authorised access to their Dropbox account, fetches the contents of our app's folder and downloads custom images accordingly
 */

private var autorisationBlock: ((success: Bool) -> Void)?

/*
 We need to make Swift happy... 😓
 */
public func handleOpenURLForDropboxer(url: NSURL, options: [String : AnyObject])
{
    if let authResult = Dropbox.handleRedirectURL(url) {
        switch authResult {
        case .Success(let token):
            dLog("Success! User is logged into Dropbox with token: \(token)")
            autorisationBlock?(success: true)
        case .Error(let error, let description):
            dLog("Error \(error): \(description)")
            autorisationBlock?(success: false)
        }
    }
    autorisationBlock = nil
}

public final class Dropboxer<C: DropboxComic, D: DropboxerDelegate>
{
    //MARK: Authorization
    /*
     This is where we handle authorising access to Dropbox
     */
    public var autorised: Bool {
        return self.client != nil
    }
    
    //MARK: Setup
    /*
     Instantiating a new Dropboxer with a delegate
     */
    public private(set) weak var delegate: D?
    
    public init(delegate: D) {
        self.delegate = delegate
        //We take this opportunity to start Dropbox
        Dropbox.setupWithAppKey("o6rb16aigty1iu5")
    }
    
    //MARK: Dropbox Client
    /*
     This is where we expose Dropbox's API
     There's not much point in reinventing the API here, so this manager is basically a collection of helper methods
     
     Ref: https://www.dropbox.com/developers/documentation/swift#tutorial
     */
    public var client: DropboxClient? {
        return Dropbox.authorizedClient
    }
    
    public final func authorise(sender: UIViewController, _ block: (success: Bool) -> Void) {
        autorisationBlock = block
        Dropbox.authorizeFromController(sender)
    }
    
    //MARK: - MAIN
    /*
     This is where we communicate with Dropbox
     */
    public private(set) var folderData: [SwiftyDropbox.Files.Metadata]?
    
    public final func listFolder()
    {
        func end(result: [SwiftyDropbox.Files.Metadata]?) {
            self.folderData = result
            self.delegate?.didListDropboxFolder(result != nil)
        }
        
        guard self.folderData == nil else { end(self.folderData); return }
        guard let client = self.client else { end(nil); return }
        
        //TODO: Optimise this using Dropbox's cursor
        client.files.listFolder(path: "").response { (result: (Files.ListFolderResult)?, error: CallError<(Files.ListFolderError)>?) in
            guard error == nil else { dLog("\(error)"); end(nil); return }
            guard let result = result else { end(nil); return }
            end(result.entries)
        }
    }
    
    public final func getPhoto(withComic comic: C)
    {
        func end(result: NSURL?) {
            self.delegate?.didDownloadFileFromDropbox(withComic: comic, andURL: result)
        }
        
        guard let client = self.client else { end(nil); return }
        guard let metadata = comic.dropboxMetadata else { end(nil); return }
        
        let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
            let fileManager = NSFileManager.defaultManager()
            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            // generate a unique name for this file in case we've seen it before
            let UUID = NSUUID().UUIDString
            let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
            return directoryURL.URLByAppendingPathComponent(pathComponent)
        }
        
        client.files.download(path: "/\(metadata.name)", destination: destination).response { (result: ((Files.FileMetadata), NSURL)?, error: CallError<(Files.DownloadError)>?) in
            guard error == nil else { dLog("\(error)"); end(nil); return }
            guard let (_, url) = result else { end(nil); return }
            end(url)
        }
    }
    
    public final func savePhoto(withData data: NSData, photoId: Int)
    {
        func end(result: SwiftyDropbox.Files.FileMetadata?) {
            self.folderData = nil
            self.delegate?.didUploadFileToDropbox(withMetadata: result)
        }
        
        guard let client = self.client else { end(nil); return }
        
        client.files.upload(path: "/\(photoId).jpg", body: data).response { (uploadResult: (Files.FileMetadata)?, uploadError: CallError<(Files.UploadError)>?) in
            guard uploadError == nil else { dLog("\(uploadError)"); end(nil); return }
            guard let _ = uploadResult else { end(nil); return }
            client.files.getMetadata(path: "/\(photoId).jpg").response { (metadataResult: (Files.Metadata)?, metadataError: CallError<(Files.GetMetadataError)>?) in
                guard metadataError == nil else { dLog("\(metadataError)"); end(nil); return }
                guard let metadata = metadataResult as? SwiftyDropbox.Files.FileMetadata else { end(nil); return }
                end(metadata)
            }
        }
    }
}
