//
//  sbComic.swift
//  StreetBees
//
//  Created by Peter Spencer on 24/06/2018.
//  Copyright © 2018 Peter Spencer. All rights reserved.
//

import Foundation


struct Comic
{
    let thumbnail: String
    let cover: String
}

extension Comic: JSONCompilable
{
    enum CompilableKeys: String
    {
        case thumbnail
        case path, `extension`
    }
    
    static func compile(jsonObject: JSONObject) -> Comic?
    {
        guard let thumbnail = jsonObject[CompilableKeys.thumbnail.rawValue] as? JSONObject,
            let path = thumbnail[CompilableKeys.path.rawValue] as? String,
            let ext = thumbnail[CompilableKeys.extension.rawValue] as? String else
        { return nil }
        
        return Comic(thumbnail: path + "/portrait_medium." + ext,
                     cover: path + "." + ext)
    }
}

