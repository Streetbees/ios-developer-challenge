//
//  Comic.swift
//  Marveble
//
//  Created by André Abou Chami Campana on 26/04/2016.
//  Copyright © 2016 Bell App Lab. All rights reserved.
//

import Foundation
import SwiftyDropbox


//MARK: - MAIN
/*
 This is the main data model
 This is where both the Marvel API and Dropbox come together
 */
public struct Comic: MarvelComic, DropboxComic {
    public let comicId: Int?
    public let title: String
    public let description: String?
    public let thumbURL: NSURL?
    public private(set) var dropboxMetadata: Files.Metadata?
    public private(set) var dropboxPhotoURL: NSURL?
    
    public init() {
        self.comicId = nil
        self.title = ""
        self.description = nil
        self.thumbURL = nil
        self.dropboxMetadata = nil
    }
    
    public init(comicId: Int, title: String, description: String?, thumbPath: String, thumbExtension: String) {
        self.comicId = comicId
        self.title = title
        self.description = description
        self.thumbURL = Comic.makeThumbURL(withPath: thumbPath, andExtension: thumbExtension)
        self.dropboxMetadata = nil
    }
    
    public mutating func setDropboxMetadata(metadata: SwiftyDropbox.Files.Metadata) -> Comic
    {
        self.dropboxMetadata = metadata
        return self
    }
    
    public mutating func setDropboxPhotoURL(url: NSURL) -> Comic
    {
        self.dropboxPhotoURL = url
        return self
    }
}


