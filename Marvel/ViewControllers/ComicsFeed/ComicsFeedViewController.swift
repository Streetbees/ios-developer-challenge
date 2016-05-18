//
//  ComicsFeedViewController.swift
//  Marvel
//
//  Created by Gabriel Massana on 17/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

import CoreDataFullStack
import PureLayout

let NavigationBarHeight: CGFloat = 64.0

class ComicsFeedViewController: UIViewController {

    //MARK: - Accessors

    /**
     Table view to display data.
     */
    lazy var tableView: UITableView = {
        
        let tableView: UITableView = UITableView.newAutoLayoutView()
        
        return tableView
    }()
    
    /**
     Adapter to  manage the common logic of the tableView.
     */
    lazy var adapter: ComicsFeedAdapter = {
        
        let adapter = ComicsFeedAdapter()
        
        adapter.delegate = self
        
        return adapter
    }()
    
    //MARK: - ViewLifeCycle

    override func viewDidLoad() {
        
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        /*-------------------*/
        
        view.addSubview(tableView)
        
        adapter.tableView = tableView
        
        /*-------------------*/
        
        paginate()
        
        /*-------------------*/
        
        updateViewConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        
        /*-------------------*/
        
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    //MARK: - RetrieveData

    /**
     Triggers the actions to download and parse comics from the API with an offset
     
     - parameter offset: the offset of data to be ask for.
     */
    private func downloadComicsFromMarvelAPI(offset: Int) {
        
        // API call to download Comics
        
        ComicsAPIManager.retrieveComics(String(offset),
                                            success: { [weak self] (result) -> Void in
                                                
                                                if let strongSelf = self {
                                                    
//                                                    strongSelf.paginate()
                                                }
            },
                                            failure: { (error) -> Void in
        })
    }
    
    /**
     Calls for a next page of data from the Marvel API if there are more content to be downloaded.
     */
    private func paginate() {
        
        self.downloadComicsFromMarvelAPI(0)
        
        CDFCoreDataManager.sharedInstance().backgroundManagedObjectContext.performBlockAndWait { () -> Void in
            
//            let feed: ComicFeed = ComicFeed.fetchComicFeed(CDFCoreDataManager.sharedInstance().backgroundManagedObjectContext)
//            
//            if feed.hasMoreContentToDownload() {
//                
//                self.downloadComicsFromMarvelAPI((feed.comics?.count)!)
//            }
        }
    }
}

extension ComicsFeedViewController : ComicsFeedAdapterDelegate {
    
    
}
