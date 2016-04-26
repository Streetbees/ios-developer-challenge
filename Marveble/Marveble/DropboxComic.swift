//
//  DropboxComic.swift
//  Marveble
//
//  Created by André Abou Chami Campana on 26/04/2016.
//  Copyright © 2016 Bell App Lab. All rights reserved.
//

import SwiftyDropbox


public protocol DropboxComic
{
    var dropboxMetadata: SwiftyDropbox.Files.Metadata? { get }
    mutating func setDropboxMetadata(metadata: SwiftyDropbox.Files.Metadata) -> Self
    var dropboxPhotoURL: NSURL? { get }
    mutating func setDropboxPhotoURL(url: NSURL) -> Self
}


public extension DropboxComic
{
    var hasDropboxData: Bool {
        return self.dropboxMetadata != nil
    }
}
