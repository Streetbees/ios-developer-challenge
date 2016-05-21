//
//  JSONParser.swift
//  MarvelBees
//
//  Created by Andy on 21/05/2016.
//  Copyright © 2016 Pyrotechnic Apps Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON



class JSONParser {
    
    func parseComics(json: JSON) -> [Comic] {
        
        var comics = [Comic]()
        
        for comicRecordDict in json["data"] {
            log.verbose("Record is: \(comicRecordDict)")
            let comicDict = comicRecordDict.1["RequestType"]
            
            do {
                
                log.debug("Comic is id, title \(comicDict["id"].intValue),\(comicDict["title"].stringValue)")
                
                let comic = try Comic (id: comicDict["id"].intValue,
                                       isbn: comicDict["isbn"].stringValue,
                                       title: comicDict["title"].stringValue,
                                       issueNumber: comicDict["issueNumber"].intValue,
                                       description: comicDict["description"].stringValue,
                                       imagePath: comicDict["imagePath"].stringValue,
                                       imageExtension: comicDict["imageExtension"].stringValue,
                                       series:	comicDict["series"].stringValue,
                                       pageCount: comicDict["pageCount"].intValue,
                                       modified: comicDict["modified"].date) // TODO: date format
                
                comics.append(comic)
                
                log.verbose("comic appended id: \(comic.id)")
                
            } catch {
                log.error("Failed to add comic iid, title, error \(comicDict["id"].intValue),\(comicDict["title"].stringValue), \(error)")
            }
            
        }
        
        log.debug("comics.count: \(comics.count)")
        return comics
        
    }
    
}
