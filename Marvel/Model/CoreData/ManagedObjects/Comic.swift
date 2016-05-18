//
//  Comic.swift
//  
//
//  Created by Gabriel Massana on 18/5/16.
//
//

import Foundation

import CoreDataFullStack

@objc(Comic)
class Comic: NSManagedObject {

    /**
     Retrieves comic from DB based with ID provided.
     
     - parameter comicID: ID of comic to be retrieved.
     - parameter managedObjectContext: context that should be used to access persistent store.
     
     - returns: Comic instance or nil if comic can't be found.
     */
    class func fetchComic(comicID:NSNumber,  managedObjectContext: NSManagedObjectContext) -> Comic? {
        
        let predicate: NSPredicate = NSPredicate(format: "comicID == %@", comicID)
        
        let comic: Comic? = CDFRetrievalService.retrieveFirstEntryForEntityClass(Comic.self, predicate: predicate, managedObjectContext: managedObjectContext) as? Comic
        
        return comic
    }
}
