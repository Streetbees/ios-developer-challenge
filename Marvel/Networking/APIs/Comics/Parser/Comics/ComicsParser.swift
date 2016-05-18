//
//  ComicsParser.swift
//  Marvel
//
//  Created by Gabriel Massana on 18/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

import CoreDataFullStack

class ComicsParser: Parser {

    //MARK: - ParseComics
    
    /**
     Parse a comics response from the Marvel API.
     
     - parameter comicsResponse: a comic response from the Marvel API
     
     - returns: An array with Comic objects parsed.
     */
    func parseComics(comicsResponse: NSArray) -> NSArray {
        
        let comicsArray: NSMutableArray = NSMutableArray(capacity: comicsResponse.count)
        
        for comicResponse in comicsResponse {
            
            let comicDictionary: NSDictionary = comicResponse as! NSDictionary
            
            let comic: Comic? = self.parseComic(comicDictionary)
            
            if comic != nil {
                
                comicsArray.addObject(comic!)
            }
        }
        
        return comicsArray.copy() as! NSArray
    }

    //MARK: - ParseComic
    
    /**
     Parse an single comic response from the Marvel API.
     
     - parameter comicResponse: a comic response from the Marvel API
     
     - returns: A Comic object parsed.
     */
    func parseComic(comicResponse: NSDictionary) -> Comic? {
        
        var comic: Comic?
        
        if let comicID = comicResponse["id"] as? NSNumber {
            
            comic = Comic.fetchComic(comicID, managedObjectContext: parserManagedObjectContext!)
            
            if (comic == nil)
            {
                comic = CDFInsertService.insertNewObjectForEntityClass(Comic.self, inManagedObjectContext: parserManagedObjectContext!) as? Comic
                
                comic?.comicID = comicID.stringValue
            }
            
            comic?.title = comicResponse["title"] as? String
            comic?.comicDescription = comicResponse["description"] as? String
            
            if let thumbnail = comicResponse["thumbnail"] as? NSDictionary {
                
                comic?.thumbnailExtension = thumbnail["extension"] as? String
                comic?.thumbnailPath = thumbnail["path"] as? String
            }
            
            
            if let dates = comicResponse["dates"] as? NSArray {
                
                for date in dates {
                    
                    if let type = date["type"] as? String,
                        let date = date["date"] as? String {
                        
                        if type == "onsaleDate" {
                            
                            let dateFormatter: NSDateFormatter = NSDateFormatter.serverDateFormatter()
                            
                            comic?.onSaleDate = dateFormatter.dateFromString(date)
                            
                            break
                        }
                    }
                }
            }
            
            comic?.parseDate = NSDate()
        }
        
        return comic
    }
}
