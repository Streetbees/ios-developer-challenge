//
//  Parser.swift
//  Marvel
//
//  Created by Gabriel Massana on 18/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

import CoreDataFullStack

/**
 Abstract parser instance with a class function to init it.
 */
class Parser: NSObject {

    //MARK: - Accessors

    /**
    NSManagedObjectContext object to be used through the parser.
    */
    var parserManagedObjectContext: NSManagedObjectContext?
    
    //MARK: - Init
    
    /**
    Instanciate a Parser with the given NSManagedObjectContext.
    
    - parameter managedObjectContext: NSManagedObjectContext object to be used through the parser.
    */
    required init(managedObjectContext: NSManagedObjectContext) {
        
        super.init()
        
        parserManagedObjectContext = managedObjectContext
    }
    
    /**
     Convenience class init with the given NSManagedObjectContext.
     
     - parameter managedObjectContext: NSManagedObjectContext object to be used through the parser.
     */
    class func parser(managedObjectContext: NSManagedObjectContext) -> Self  {
        
        return self.init(managedObjectContext: managedObjectContext)
    }
}
