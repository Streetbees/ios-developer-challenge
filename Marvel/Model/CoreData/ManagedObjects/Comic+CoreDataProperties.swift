//
//  Comic+CoreDataProperties.swift
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

extension Comic {

    @NSManaged var title: String?
    @NSManaged var comicDescription: String?
    @NSManaged var thumbnailExtension: String?
    @NSManaged var thumbnailPath: String?
    @NSManaged var onSaleDate: NSDate?
    @NSManaged var comicID: String?
    @NSManaged var feed: ComicFeed?
    @NSManaged var parseDate: NSDate?
}
