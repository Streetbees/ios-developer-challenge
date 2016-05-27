//
//  ComicTableViewController.swift
//  MarvelBees
//
//  Created by Andy on 21/05/2016.
//  Copyright © 2016 Pyrotechnic Apps Ltd. All rights reserved.
//

import UIKit
import SwiftyDropbox

class ComicTableViewController: UITableViewController {
    
    var comics = [Comic]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.loadComicData()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)

        // Add "pull to refresh"
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "")
        self.refreshControl?.addTarget(self, action: #selector(ComicTableViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        self.refreshData()
        
        // Add observer, so we can refresh tableview once fetch has completed
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComicTableViewController.comicFetchDidSucceed(_:)), name: MarvelAPI.ComicFetchDidSucceedNotification, object: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comics.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ComicCell", forIndexPath: indexPath) as! ComicTableViewCell
        
        let backgroundView = UIView()
        cell.selectedBackgroundView = backgroundView
        
        log.debug("cell for row at index path \(indexPath.row)")
        if comics.count > 0 {
            let comic = comics[indexPath.row]
            if let title = comic.title {
                cell.title.text = title
            }
            
            if let description = comic.description {
                cell.summary.text = description
            }
            
            // If we have image path, then replace placeholder image
            if let imagePath = comic.imagePath, imageExtension = comic.imageExtension {
                let imageURL = "\(imagePath).\(imageExtension)"
                log.debug("imageURL: \(imageURL)")

                MarvelAPI.sharedInstance.replaceImageWithURLString(imageURL, comic:comic, imageToReplace: cell.coverThumbnail, placeholderImage: UIImage(named: "marvel")!)
            }
            
        }
        
        if indexPath.row == comics.count - 1 {
            loadComicData()
        }
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        super.prepareForSegue(segue, sender: sender)
        // Change back button text on next scene
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        // Set the comic object
        // Get current row details, note optional
        if let indexPath = self.tableView.indexPathForSelectedRow {
            
            let currentComic = comics[indexPath.row]
                // Get the new view controller
                let comicScene = segue.destinationViewController as! ComicViewController
                comicScene.currentComic = currentComic
        }
        else
        {
            log.debug("Error in jobs") //TODO improve
        }
        
    }
    
    
    var isLoading = false
    // Handle loading of data
    private func loadComicData()
    {
        
        if !isLoading {
            
            isLoading = true
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            MarvelAPI.sharedInstance.fetchComics(comics.count) {success, comics in
                
                if self.comics.count == 0 {
                    self.refreshControl!.endRefreshing()
                }
                
                if success {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    self.comics.appendContentsOf(comics)
                    
                    self.refreshData()
                    
                    log.debug("Fetched comics ok, comics.count \(comics.count)")
                }
                else
                {
                    log.debug("Fetched comics failed")
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
                
                self.isLoading = false
            }
        }
        
        
    }
    
    
    private func refreshData() {
        self.tableView.reloadData()
    }
    

    func refresh()
    {
        comics.removeAll()
        loadComicData()
        refreshData()
    }
    
    
    // MARK: - Notification handlers
    func comicFetchDidSucceed(notification: NSNotification) {
        
        log.debug("Notification that API fetch completed ok")
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MarvelAPI.ComicFetchDidSucceedNotification, object: nil)
        
        refresh()
        
    }
    
    
    // MARK: - Dropbox
    @IBAction func linkButtonPressed(sender: AnyObject) {
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        } else {
            print("User is already authorized!")
        }
    }
    
  
    
}
