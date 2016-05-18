//
//  ComicFeed.swift
//  
//
//  Created by Gabriel Massana on 18/5/16.
//
//

import Foundation

import CoreDataFullStack

let ComicFeedID: String = "-1"

@objc(ComicFeed)
class ComicFeed: NSManagedObject {

    //MARK: - Fetch
    
    /**
     Retrieves comicFeed from DB based with ID provided.
     
     - parameter feedID: ID of comicFeed to be retrieved.
     - parameter managedObjectContext: context that should be used to access persistent store.
     
     - returns: ComicFeed instance or nil if comic can't be found.
     */
    private class func fetchComicFeed(feedID:String,  managedObjectContext: NSManagedObjectContext) -> ComicFeed? {
        
        let predicate: NSPredicate = NSPredicate(format: "feedID MATCHES %@", feedID)
        
        let feed: ComicFeed? = CDFRetrievalService.retrieveFirstEntryForEntityClass(ComicFeed.self, predicate: predicate, managedObjectContext: managedObjectContext) as? ComicFeed
        
        do {
            
            try managedObjectContext.save()
        }
        catch
        {
            print(error)
        }
        
        return feed
    }
    
    /**
     Fetches or create a comicFeed.
     
     - parameter managedObjectContext: context that should be used to access persistent store.
     
     - returns: ComicFeed instance.
     */
    class func fetchComicFeed(managedObjectContext: NSManagedObjectContext) -> ComicFeed {
        
        var feed: ComicFeed? = ComicFeed.fetchComicFeed(ComicFeedID, managedObjectContext: managedObjectContext)
        
        if let aFeed: ComicFeed = feed {
            
            return aFeed
        }
        else
        {
            feed = CDFInsertService.insertNewObjectForEntityClass(ComicFeed.self, inManagedObjectContext: managedObjectContext) as? ComicFeed
            
            feed!.feedID = ComicFeedID
            
            return feed!
        }
    }
    
    //MARK: - MoreContent
    
    /**
     Asks the feed if there are more content to download based on stored parameters
     
     - returns: True if there are more content to download. False otherwise
     */
    func hasMoreContentToDownload() -> Bool {
        
        var hasMoreContentToDownload: Bool = false
        
        if (totalComics?.integerValue != comics!.count ||
            totalComics?.integerValue == 0) {
            
            hasMoreContentToDownload = true
        }
        
        return hasMoreContentToDownload
    }
}
