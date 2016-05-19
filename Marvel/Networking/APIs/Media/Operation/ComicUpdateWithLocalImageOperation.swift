//
//  ComicUpdateWithLocalImageOperation.swift
//  Marvel
//
//  Created by Gabriel Massana on 18/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

import CoreOperation
import CoreDataFullStack

class ComicUpdateWithLocalImageOperation: COMOperation {

    //MARK: - Accessors

    /**
     Comic ID to be updated.
     */
    var comicID: String?
    
    /**
     The image to be saved on disk
     */
    var image: UIImage?
    
    //MARK: - Init
    
    init(image: UIImage, comicID: String) {
        
        super.init()
        
        self.comicID = comicID
        
        identifier = String(format:"ComicUpdateWithLocalImageOperation-%@", comicID)
    }
    
    override init() {
        
        super.init()
    }
    
    //MARK: - Start
    
    override func start() {
        
        super.start()
        
        CDFCoreDataManager.sharedInstance().backgroundManagedObjectContext.performBlockAndWait { () -> Void in
            
            guard let comicID = self.comicID else {
                
                self.didFailWithError(nil)
                
                return;
            }
            
            let comic = Comic.fetchComic(comicID, managedObjectContext: CDFCoreDataManager.sharedInstance().backgroundManagedObjectContext)
            
            comic?.withLocalImage = true
            
            do {
                try CDFCoreDataManager.sharedInstance().backgroundManagedObjectContext.save()
                
                self.didSucceedWithResult(comicID)
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
