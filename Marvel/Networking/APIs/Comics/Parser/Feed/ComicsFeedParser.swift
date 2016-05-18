//
//  ComicsFeedParser.swift
//  Marvel
//
//  Created by Gabriel Massana on 18/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

class ComicsFeedParser: Parser {

    //MARK: - ParseFeed
    
    /**
     Parse a feed response from the Marvel API.
     
     - parameter serverResponse: a feed response from the Marvel API
     
     - returns: A ComicFeed objects parsed.
     */
    func parseFeed(serverResponse: NSDictionary) -> ComicFeed {
        
        let feed: ComicFeed = ComicFeed.fetchComicFeed(parserManagedObjectContext!)
        
        if let data = serverResponse["data"] as? NSDictionary {
            
            let total: NSNumber? = data["total"]! as? NSNumber
            
            feed.totalComics = total
            
            let results: NSArray? = data["results"] as? NSArray
            
            if let results = results {
                
                let parser: ComicsParser = ComicsParser.parser(parserManagedObjectContext!)
                
                let comics: NSArray = parser.parseComics(results)
                
                for comic in comics {
                    
                    (comic as! Comic).feed = feed
                }
            }
        }
        else
        {
            feed.lastServerFailure = NSDate()
        }
        
        return feed
    }
}
