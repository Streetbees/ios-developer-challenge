//
//  ComicsParserOperation.swift
//  Marvel
//
//  Created by Gabriel Massana on 18/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

import CoreOperation
import CoreDataFullStack

class ComicsParserOperation: COMOperation {

    //MARK: - Accessors
    
    /**
     The comics response from Marvel API to be parsed.
     */
    var comicsResponse: NSDictionary?
    
    /**
     The offset value
     */
    var offset: String?
    
    //MARK: - Init
    
    init(comicsResponse: NSDictionary, offset: String) {
        
        super.init()
        
        self.comicsResponse = comicsResponse
        self.offset = offset
        
        identifier = String(format:"ComicsParserOperation-%@", offset)
    }
    
    override init() {
        
        super.init()
    }
    
    //MARK: - Start
    
    override func start() {
        
        super.start()
        
        CDFCoreDataManager.sharedInstance().backgroundManagedObjectContext.performBlockAndWait { () -> Void in
            
            let feedParser: ComicsFeedParser = ComicsFeedParser.parser(CDFCoreDataManager.sharedInstance().backgroundManagedObjectContext)
            
            guard let response = self.comicsResponse else {
                
                self.didFailWithError(nil)

                return
            }
            
            let feed: ComicFeed = feedParser.parseFeed(response)
            
            do {
                try CDFCoreDataManager.sharedInstance().backgroundManagedObjectContext.save()
                
                self.didSucceedWithResult(feed.feedID)
            }
            catch
            {
                print(error)
                self.didFailWithError(nil)
            }
        }
    }
    
    //MARK: - Cancel
    
    override func cancel() {
        
        super.cancel()
        
        didSucceedWithResult(nil)
    }
}
