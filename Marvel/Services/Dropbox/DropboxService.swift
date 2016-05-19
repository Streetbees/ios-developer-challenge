//
//  DropboxService.swift
//  Marvel
//
//  Created by GabrielMassana on 19/05/2016.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

let AppSecret = "iehwao14bacugjv"
let AppKey = "yqkyrhm9htd5pp3"

class DropboxService: NSObject {

    //MARK: - Accessors

    let session: DBSession = {
        
        let session = DBSession(appKey: AppKey, appSecret: AppSecret, root: kDBRootAppFolder)

        return session
    }()

    lazy var restClient: DBRestClient = {
       
        let restClient: DBRestClient = DBRestClient(session: DBSession.sharedSession())
        restClient.delegate = self
        
        return restClient
    }()
    
    //MARK: - Singleton

    static let sharedInstance = DropboxService()
    
    
    //MARK: - Init
    
    override init() {
        
        DBSession.setSharedSession(session)
    }
    
    /**
     Upload images to Dropbox Apps
     
     - parameter comicID: comid ID of the image to be uploaded.
     */
    func uploadImage(comicID: String) {
        
        let cacheDirectory: String = NSFileManager.cfm_cacheDirectoryPath()
        let absolutePath: String = cacheDirectory.stringByAppendingString(String(format: "/%@_%@", comicID, MediaAspectRatio.Camera.rawValue))
        
        let destinationFolder = "/"
        let filename = comicID + ".jpg"
        
        restClient.uploadFile(filename, toPath: destinationFolder, withParentRev:nil, fromPath: absolutePath)
    }
}

extension DropboxService : DBRestClientDelegate {
    
    func restClient(client: DBRestClient!, uploadFileFailedWithError error: NSError!) {
        
        print(error)
    }
    
    func restClient(client: DBRestClient!, uploadedFile destPath: String!, from srcPath: String!) {
        
        print("File uploaded successfully to path: " + destPath)
    }
}
