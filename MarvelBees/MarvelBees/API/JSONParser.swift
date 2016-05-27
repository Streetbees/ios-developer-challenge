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
        
        // We need to go one level deeper, data to results
        
        for comicRecordDict in json["data"]["results"] {
            //log.debug("Dump of comicRecordDict")  // this is 1 Item
            dump(comicRecordDict)
            
            let comicDict = comicRecordDict.1
            // log.verbose(<#T##closure: String?##String?#>)("Dump of comicDict")
            // dump(comicDict)
            do {
                
                log.debug("Comic is id: \(comicDict["id"].intValue), title: \(comicDict["title"].stringValue), onSaleDate: \(comicDict["onsaleDate"].stringValue)")
                
                let comic = try Comic (id: comicDict["id"].intValue,
                                       isbn: comicDict["isbn"].stringValue,
                                       title: comicDict["title"].stringValue,
                                       issueNumber: comicDict["issueNumber"].intValue,
                                       description: comicDict["description"].stringValue,
                                       imagePath: comicDict["thumbnail"]["path"].stringValue,
                                       imageExtension: comicDict["thumbnail"]["extension"].stringValue,
                                       series:	comicDict["series"].stringValue,
                                       pageCount: comicDict["pageCount"].intValue) // TODO: date format
                
                comics.append(comic)
                log.debug("onSaleDate: \(comicDict["onSaleDate"].stringValue)")
                
                log.debug("comic appended id: \(comic.id)")
            
                
            } catch {
                log.error("Failed to add comic id: \(comicDict["id"].intValue)  title error ,\(comicDict["title"].stringValue), \(error)")
            }
        }
        
        log.verbose("comics.count: \(comics.count)")
        //log.verbose("Dumping comics")
        //dump(comics)
        return comics
        
    }
    

    
}
