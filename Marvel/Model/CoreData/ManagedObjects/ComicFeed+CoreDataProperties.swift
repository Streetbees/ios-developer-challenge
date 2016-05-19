//
//  ComicFeed+CoreDataProperties.swift
//  
//
//  Created by Gabriel Massana on 18/5/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ComicFeed {

    @NSManaged var feedID: String?
    @NSManaged var totalComics: NSNumber?
    @NSManaged var comics: NSSet?

}
