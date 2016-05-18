//
//  ComicsFeedAdapter.swift
//  Marvel
//
//  Created by Gabriel Massana on 18/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

import CoreDataFullStack

protocol ComicsFeedAdapterDelegate: class {
    
    /**
     Callback for when the user selects one comic.
     
     - parameter comic: the selected comic object.
     */
//    func didSelectComic(comic: Comic)
}

class ComicsFeedAdapter: NSObject {

    //MARK: - Accessors
    
    /**
     Delegate object
     */
    weak var delegate: ComicsFeedAdapterDelegate?
 
    /**
     Table view to display data.
     */
    var tableView: UITableView! {
        
        willSet (newValue) {
            
            if newValue != tableView {
                
                self.tableView = newValue
                
                tableView.dataSource = self
                tableView.delegate = self
                tableView.backgroundColor = UIColor.whiteColor()
                tableView.rowHeight = 120.0
                tableView.separatorStyle = .None
                
                //RegisterCells
                registerCells()
                
                do {
                    
                    try self.fetchedResultsController.performFetch()
                }
                catch
                {
                    
                }
            }
        }
    }
    
    /**
     Used to connect the TableView with Core Data.
     */
    lazy var fetchedResultsController: CDFTableViewFetchedResultsController =  {
        
        let fetchedResultsController = CDFTableViewFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: CDFCoreDataManager.sharedInstance().managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.tableView = self.tableView
        
        return fetchedResultsController
    }()
    
    /**
     Fetch request for retrieving characters.
     */
    var fetchRequest: NSFetchRequest {
        
        let fetchRequest = NSFetchRequest()
        
        fetchRequest.entity = NSEntityDescription.entityForName(NSStringFromClass(Comic.self), inManagedObjectContext: CDFCoreDataManager.sharedInstance().managedObjectContext)
        fetchRequest.sortDescriptors = sortDescriptors
        
        return fetchRequest
    }
    
    /**
     Sort Descriptors to sort how characters should be ordered.
     */
    lazy var sortDescriptors: Array<NSSortDescriptor> = {
        
        let sortDescriptors:NSSortDescriptor = NSSortDescriptor(key: "onSaleDate", ascending: false)
        
        return [sortDescriptors]
    }()
    
    //MARK: - RegisterCells
    
    /**
     Register the cells to be used in the table view.
     */
    func registerCells() {
        
        tableView.registerClass(ComicFeedCell.self, forCellReuseIdentifier: ComicFeedCell.reuseIdentifier())
    }
    
    //MARK: - ConfigureCell
    
    /**
     Configure the cell.
     
     - parameter cell: cell to be configured.
     - parameter indexPath: cell indexPath.
     */
    func configureCell(cell:UITableViewCell, indexPath: NSIndexPath) {
        
        let comic: Comic = fetchedResultsController.fetchedObjects![indexPath.row] as! Comic
        
        let cell = cell as! ComicFeedCell
        
        cell.configureWithComic(comic)
    }
    
    
    
    //MARK: - RetrieveData
    
    /**
     Triggers the actions to download and parse comics from the API with an offset
     
     - parameter offset: the offset of data to be ask for.
     */
    private func downloadComicsFromMarvelAPI(offset: Int) {
        
        // API call to download Comics
        
        ComicsAPIManager.retrieveComics(String(offset),
                                        success: {(result) -> Void in
            },
                                        failure: {(error) -> Void in
        })
    }
    
    /**
     Calls for a next page of data from the Marvel API if there are more content to be downloaded.
     */
    func paginate() {
        
        CDFCoreDataManager.sharedInstance().backgroundManagedObjectContext.performBlockAndWait { () -> Void in
            
            let feed: ComicFeed = ComicFeed.fetchComicFeed(CDFCoreDataManager.sharedInstance().backgroundManagedObjectContext)
            
            if feed.hasMoreContentToDownload() {
                
                self.downloadComicsFromMarvelAPI((feed.comics?.count)!)
            }
        }
    }

}

//MARK: - UITableViewDataSource

extension ComicsFeedAdapter: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (fetchedResultsController.fetchedObjects?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ComicFeedCell.reuseIdentifier(), forIndexPath: indexPath) as! ComicFeedCell
        
        configureCell(cell, indexPath: indexPath)
        
        cell.layoutByApplyingConstraints()
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ComicsFeedAdapter: UITableViewDelegate {
    
}