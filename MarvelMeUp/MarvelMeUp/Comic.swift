//
//  Comic.swift
//  MarvelMeUp
//
//  Created by Dimitar Chakarov on 5/23/16.
//  Copyright © 2016 JI Apps Ltd. All rights reserved.
//

import Foundation

struct Comic {
    let id: Int
    let title: String
    let thumbnail: String
    let image: String
    var imageURL: NSURL {
        get {
            return NSURL(string: self.image)!
        }
    }
    var thumbnailURL: NSURL {
        get {
            return NSURL(string: self.thumbnail)!
        }
    }
    var replaced: Bool? = nil

    init?(fromDict dict: [String: AnyObject]) {
        if let
            id = dict["id"] as? Int,
            title = dict["title"] as? String,
            thumbnailData = dict["thumbnail"] as? [String: String],
            thumbnailPath = thumbnailData["path"],
            thumbnailExt = thumbnailData["extension"] {
            self.id = id
            self.title = title
            self.thumbnail = thumbnailPath + "/" + Config.marvelThumbnailName + "." + thumbnailExt
            self.image = thumbnailPath + "/" + Config.marvelImageName + "." + thumbnailExt
        } else {
            return nil
        }
    }
}