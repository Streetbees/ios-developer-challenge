//
//  Comic.swift
//  Marveble
//
//  Created by André Abou Chami Campana on 26/04/2016.
//  Copyright © 2016 Bell App Lab. All rights reserved.
//

import Foundation


//MARK: - MAIN
/*
 This is the main data model
 This is where both the Marvel API and Dropbox come together
 */
struct Comic: MarvelComic {
    let comicId: Int?
    let title: String
    let description: String?
    let thumbURL: NSURL?
    
    init() {
        self.comicId = nil
        self.title = ""
        self.description = nil
        self.thumbURL = nil
    }
    
    init(comicId: Int, title: String, description: String?, thumbPath: String, thumbExtension: String) {
        self.comicId = comicId
        self.title = title
        self.description = description
        self.thumbURL = Comic.makeThumbURL(withPath: thumbPath, andExtension: thumbExtension)
    }
}
