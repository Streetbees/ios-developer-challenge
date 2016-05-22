//
//  ComicTableViewController.swift
//  MarvelBees
//
//  Created by Andy on 21/05/2016.
//  Copyright © 2016 Pyrotechnic Apps Ltd. All rights reserved.
//

import UIKit

class ComicTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        // Temp, shift out later
        let authentication = Authentication()
        let hash = authentication.generateHash()
        log.debug("Key is: \(hash)")
        
        // MarvelAPI.sharedInstance.fetchComics()
        
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "")
        // self.refreshControl?.addTarget(self, action: #selector(ComicTableViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.loadComicData()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    private func loadComicData()
    {
        self.refreshControl!.endRefreshing()
        
        MarvelAPI.sharedInstance.fetchComics() {success, comics in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if success {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                log.debug("Fetched comics ok")
            }
            else
            {
                log.debug("Fetched comics failed")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
        
            /*            FlattyAPI.sharedInstance.fetchJobs(currentUser) { success, jobs in
             // Completion handler - called when network call has completed
             MRProgressOverlayView.appearance().tintColor = self.view.tintColor
             MRProgressOverlayView.showOverlayAddedTo(appDelegate.window, title: "Loading Jobs", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
             // Update tableView data
             if success {
             MRProgressOverlayView.dismissOverlayForView(appDelegate.window, animated:true)
             log.debug("Fetched \(jobs.count) jobs")
             var tmpRequestStatuses = [Int: String]()   // Dictionary mapping a statusId to its string value
             var tmpOrderedStatusIds = [Int]()          // Array of statusIds in the order we want to display them (ordered by request_statuses.order_by_override)
             var tmpJobsByStatus = [Int: [Job]]()       // Dictionary mapping a statusId to a list of Jobs
             for job in jobs {
             tmpRequestStatuses[job.requestStatusId] = "\(job.requestStatusName)"
             
             // See if we already have a list of Jobs for the current statusId
             // Populate the array with the existing dictionary value
             // (ie array of jobs for that status)
             if var statusJobs = tmpJobsByStatus[job.requestStatusId]
             {   // append to our jobs array
             statusJobs.append(job)
             // Overwrite this dictionary entry for this status
             // to our new appended array
             tmpJobsByStatus[job.requestStatusId] = statusJobs
             }
             else {
             // Otherwise create the array
             var statusJobs = [Job]()
             // Append this job
             statusJobs.append(job)
             // Set dictionary entry for this request id to contain this array (With 1 job)
             tmpJobsByStatus[job.requestStatusId] = statusJobs
             }
             }
             // Now sort the dictionary by the key
             // TODO: Sort by request_statuses.order_by_override when available
             tmpOrderedStatusIds = tmpRequestStatuses.keys.sort()
             
             // Save all tableView data at once for consistency
             self.requestStatuses = tmpRequestStatuses
             self.orderedStatusIds = tmpOrderedStatusIds
             self.jobsByStatus = tmpJobsByStatus
             
             // Finally, refresh the tableView to show new jobs
             self.refreshData()
             }
             else
             {
             MRProgressOverlayView.dismissOverlayForView(appDelegate.window, animated:false)
             MRProgressOverlayView.showOverlayAddedTo(appDelegate.window, title: "", mode: MRProgressOverlayViewMode.Cross, animated: true)
             UIApplication.sharedApplication().networkActivityIndicatorVisible = false
             }
             }
             */
        }
        
        
        private func refreshData() {
            self.tableView.reloadData()
        }
        
        
        func refresh()
        {
            loadComicData()
            refreshData()
        }
        
        
        /*
         override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
         
         // Configure the cell...
         
         return cell
         }
         */
        
        /*
         // Override to support conditional editing of the table view.
         override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
         }
         */
        
        /*
         // Override to support editing the table view.
         override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
         if editingStyle == .Delete {
         // Delete the row from the data source
         tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
         } else if editingStyle == .Insert {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
         }
         */
        
        /*
         // Override to support rearranging the table view.
         override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
         
         }
         */
        
        /*
         // Override to support conditional rearranging of the table view.
         override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         // Return false if you do not want the item to be re-orderable.
         return true
         }
         */
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
        
}
