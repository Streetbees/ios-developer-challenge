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
                
//                do {
//                    
//                    try self.fetchedResultsController.performFetch()
//                }
//                catch
//                {
//                    
//                }
            }
        }
    }
    
    //MARK: - RegisterCells
    
    /**
     Register the cells to be used in the table view.
     */
    func registerCells() {
        
//        tableView.registerClass(CharactersFeedCell.self, forCellReuseIdentifier: CharactersFeedCell.reuseIdentifier())
    }

}

//MARK: - UITableViewDataSource

extension ComicsFeedAdapter: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        return (fetchedResultsController.fetchedObjects?.count)!
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCellWithIdentifier(CharactersFeedCell.reuseIdentifier(), forIndexPath: indexPath) as! CharactersFeedCell
//        
//        configureCell(cell, indexPath: indexPath)
//        
//        cell.layoutByApplyingConstraints()
//        
//        return cell
        
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate

extension ComicsFeedAdapter: UITableViewDelegate {
    
}