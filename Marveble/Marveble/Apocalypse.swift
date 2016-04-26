//
//  Apocalypse.swift
//  Marveble
//
//  Created by André Abou Chami Campana on 26/04/2016.
//  Copyright © 2016 Bell App Lab. All rights reserved.
//

import Foundation
import UILoader
import SwiftyDropbox
import Backgroundable


//MARK: - Apucalypse Delegate
public protocol ApocalypseDelegate: UILoader
{
    func didFinishLoadingEverything(errorMessage: String?)
    func didUpdateComic(comic: Comic)
}

//MARK: - MAIN
/*
 This is the end (point)
 This controller has two horsemen, Marveler and Dropboxer and it makes sure both of them are in sync
 View Controllers should refer to this controller to get their data
 */
public final class Apocalypse<D: ApocalypseDelegate>: MarvelerDelegate, DropboxerDelegate
{
    //MARK: Setup
    /*
     Instantiating a new Dropboxer with a delegate
     */
    public private(set) weak var delegate: D?
    
    public init(delegate: D) {
        self.delegate = delegate
    }
    
    //MARK: MAIN
    //TODO: Optimise this to better cache results
    public final func loadEverything(withStartingIndex startingIndex: NSIndexPath, andEndIndex endIndex: NSIndexPath)
    {
        self.marveler.getComics(startingAt: startingIndex.row)
    }
    
    private var currentUploadingComic: DC? = nil
    
    public final func uploadImage(image: UIImage, toComic comic: M) {
        guard let comicId = comic.comicId else { return }
        guard let data = UIImageJPEGRepresentation(image, 0.8) else { return }
        self.currentUploadingComic = comic
        self.dropboxer.savePhoto(withData: data, photoId: comicId)
    }
    
    //MARK: Marveler
    public typealias M = Comic
    
    public private(set) lazy var marveler: Marveler<Comic, Apocalypse> = Marveler(delegate: self)
    
    public final func willStartLoadingMarvelComics() {
        self.delegate?.loading = true
    }
    
    public final func willFinishLoadingMarvelComics(errorMessage: String?) {
        self.delegate?.loading = false
        self.dropboxer.listFolder()
    }
    
    public final func didFinishLoadingMarvelComics<M>(comic: M) {
        self.delegate?.didUpdateComic(comic as! Comic)
    }
    
    //MARK: Dropboxer
    public typealias DC = Comic
    
    public private(set) lazy var dropboxer: Dropboxer<Comic, Apocalypse> = Dropboxer(delegate: self)
    
    public func didChangeDropboxAuthorisation(granted: Bool) {
        guard granted else { return }
        self.dropboxer.listFolder()
    }
    
    //Upon listing the contents of our Dropbox folder, we investigate existing photos there
    public func didListDropboxFolder(success: Bool)
    {
        if success {
            inTheBackground { [weak self] _ in
                guard let folderData = self?.dropboxer.folderData else { return }
                guard let currentComics = self?.marveler.comics else { return }
                
                func findComic(withName name: String) -> Comic? {
                    for comic in currentComics {
                        if comic.hasBeenSummoned && "\(comic.comicId!)" == name.stringByReplacingOccurrencesOfString(".jpg", withString: "") {
                            return comic
                        }
                    }
                    return nil
                }
                for metadata in folderData {
                    if var foundComic = findComic(withName: metadata.name) {
                        self?.dropboxer.getPhoto(withComic: foundComic.setDropboxMetadata(metadata))
                    }
                }
            }
        }
    }
    
    public func didDownloadFileFromDropbox<DC>(withComic comic: DC, andURL url: NSURL?) {
        guard let url = url else { return }
        guard var c = comic as? Comic else { return }
        self.marveler.updateComics([c.setDropboxPhotoURL(url)]) //This will channel messages to the Apocalypse delegate
    }
    
    public func didUploadFileToDropbox(withMetadata metadata: SwiftyDropbox.Files.FileMetadata?) {
        guard let metadata = metadata else { return }
        guard var current = self.currentUploadingComic else { return }
        self.currentUploadingComic = nil
        self.marveler.updateComics([current.setDropboxMetadata(metadata)]) //This will channel messages to the Apocalypse delegate
    }
}
